import UIKit

//MARK: - Основной класс приложения
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    
    ///Счетчик вопросов
    private var currentQuestionIndex = 0
    ///Кол-во правильных ответов
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    ///Переменная для изменения цвета StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButtonClicked: UIButton!
    @IBOutlet private var noButtonClicked: UIButton!
    
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
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
           let viewModel = convert(model: question)
           DispatchQueue.main.async { [weak self] in
               self?.show(quiz: viewModel)
           }
    }
    
    //MARK: - Методы (Логика работы)
    /// Метод для ковертации вопросов из мока
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    /// Метод для отображения вопросов
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView?.image = step.image
        textLabel.text = step.question
       
        buttonIsEnabled(Bool: true) //метод для включение кнопок
        
        imageView?.layer.borderWidth = 0 //Убрать рамку с появление нового вопроса(showAnswerResult)
    }
    
    // Метод, для отображение рамки правильного и не правильного ответа
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1 //счет очков если правильны ответ
        }
        imageView?.layer.masksToBounds = true
        imageView?.layer.borderWidth = 8
        imageView?.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        buttonIsEnabled(Bool: false) // Метод для выключения кнопок
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    /// Логика перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            show()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    ///Метод для отображения алерта с результатми игры
    func show() {
        let model = AlertModel(title: "Этот раунд окончен!", message: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть ещё раз", completion: {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        AlertPresenter.showAlert(from: self, model: model)
    }
    
    ///Метод включения выключения кнопок во время показа результата
    private func buttonIsEnabled(Bool: Bool) {
        noButtonClicked.isEnabled = Bool
        yesButtonClicked.isEnabled = Bool
    }
}
