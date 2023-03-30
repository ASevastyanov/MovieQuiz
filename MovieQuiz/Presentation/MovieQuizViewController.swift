import UIKit


// MARK: - Структуры приложения

///Структура для конвертации вопросов с мока
struct QuizQuestion {
    /// Строка с названием фильма, совпадает с названием картинки афиши фильма в Assets
    let image: String
    /// Строка с вопросом о рейтинге фильма
    let text: String
    /// Булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}

/// Вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    // Картинка с афишей фильма с типом UIImage
    let image: UIImage
    // Вопрос о рейтинге квиза
    let question: String
    // Строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}

///Стуктура для работы алерта
struct QuizResultsViewModel {
    /// Строка с заголовком алерта
    let title: String
    /// Строка с текстом о количестве набранных очков
    let text: String
    /// Секст для кнопки алерта
    let buttonText: String
}

//MARK: - Основной класс приложения
final class MovieQuizViewController: UIViewController {
    
    /// Моки данных для квиза
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    ///Счетчик вопросов
    private var currentQuestionIndex = 0
    ///Rол-во правильных ответов
    private var correctAnswers = 0
    
    ///Переменная для изменения цвета StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButtonClicked: UIButton!
    @IBOutlet private var noButtonClicked: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        print("Press YES")
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        print("Press NO")
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let questionStep = convert(model: currentQuestion)
        show(quiz: questionStep)
    }
    
    //MARK: - Методы (Логика работы)
    /// Метод для ковертации вопросов из мока
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        print("Конвертация QuizQuestion/ вопрос - \(currentQuestionIndex + 1)")
        return questionStep
    }
    
    /// Метод для отображения вопросов
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView?.image = step.image
        textLabel.text = step.question
       
        buttonisEnabled(Bool: true) //метод для включение кнопок
        
        imageView?.layer.borderWidth = 0 //Убрать рамку с появление нового вопроса(showAnswerResult)
        print("Метод для отображения впороса \(step.questionNumber)")
    }
    
    // Метод, для отображение рамки правильного и не правильного ответа
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1 //счет очков если правильны ответ
            print("Ответ засчитан \(correctAnswers)")
        }
        print("Ответ верный? = \(isCorrect)")
        imageView?.layer.masksToBounds = true
        imageView?.layer.borderWidth = 8
        imageView?.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        buttonisEnabled(Bool: false) // Метод для выключения кнопок
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    /// Логика перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            print("Алерт вызван")
            let resultQuiz = QuizResultsViewModel (
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/10",
                buttonText: "Сыграть ещё раз")
            show(quiz: resultQuiz)
        } else {
            print("Запущен следующий раунд")
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    /// Метод работы с результатами квиза
    private func show(quiz result: QuizResultsViewModel) {
        print("Алерт показан")
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    ///Метод включения выключения кнопок во время показа результата
    private func buttonisEnabled(Bool: Bool){
        noButtonClicked.isEnabled = Bool
        yesButtonClicked.isEnabled = Bool
    }
}
