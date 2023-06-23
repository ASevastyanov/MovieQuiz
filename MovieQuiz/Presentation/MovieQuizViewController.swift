import UIKit

//MARK: - Основной класс приложения
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Propeties
    ///Кол-во правильных ответов
    private var correctAnswers = 0
    var correctAnswersToQuestion = 0
    // Делегаты
    private var alertPresenter: AlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    ///Переменная для изменения цвета StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView?.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.requestNextQuestion()
        
        showLoadingIndicator(shouldShow: true)
        questionFactory?.loadData()
        
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convertQuestions(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.showQuiz(quiz: viewModel)
        }
    }
    
    //MARK: - Методы (Логика работы)
    /// Метод для отображения вопросов
    private func showQuiz(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView?.image = step.image
        textLabel.text = step.question
        
        buttonIsEnabled(Bool: true) //метод для включение кнопок
        showLoadingIndicator(shouldShow: false)
        
        imageView?.layer.borderWidth = 0 //Убрать рамку с появление нового вопроса(showAnswerResult)
    }
    
    /// Метод, для отображение рамки правильного и не правильного ответа
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1 //счет очков если правильны ответ
            correctAnswersToQuestion = correctAnswers
        }
        imageView?.layer.masksToBounds = true
        imageView?.layer.borderWidth = 8
        imageView?.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        buttonIsEnabled(Bool: false) // Метод для выключения кнопок
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            sleep(1)
            self.showLoadingIndicator(shouldShow: true)
        }
    }
    
    /// Логика перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            showResult()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    ///Метод для отображения алерта с результатми игры
    private func showResult() {
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: makeResultMassage(),
                                    buttonText: "Сыграть еще раз",
                                    completion: { [weak self] in
            guard let self else {return}
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(with: alertModel)
    }
    
    ///Генерация результата для алерта
    private func makeResultMassage() -> String {
        
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("Error massge")
            return ""
        }
        
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)"
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) " + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMassage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMassage
    }
    
    ///Метод включения выключения кнопок во время показа результата
    private func buttonIsEnabled(Bool: Bool) {
        noAnswerButton.isEnabled = Bool
        yesAnswerButton.isEnabled = Bool
    }
    
    private func showLoadingIndicator(shouldShow: Bool) {
        if shouldShow == true {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func showNetworkError(message: String) {
        showLoadingIndicator(shouldShow: true)
        buttonIsEnabled(Bool: false)
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать еще раз",
                                    completion: { [weak self] in
            guard let self else { return }
            self.questionFactory?.loadData()
        })
        alertPresenter?.showAlert(with: alertModel)
    }
    
    func didLoadDataFromServer() {
        showLoadingIndicator(shouldShow: false)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
