import UIKit

//MARK: - Основной класс приложения
final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        imageView?.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        self.presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    //MARK: - Methods
    func showQuiz(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView?.image = step.image
        textLabel.text = step.question
        
        buttonIsEnabled(Bool: true)
        showLoadingIndicator(shouldShow: false)
        turnOffFrame()
    }
    
    func showAlertResult() {
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: presenter.makeResultMassage(),
                                    buttonText: "Сыграть еще раз",
                                    completion: { [weak self] in
            guard let self else {return}
            self.presenter.restarGame()
        })
        
        turnOffFrame()
        alertPresenter?.showAlert(with: alertModel)
    }
    
    func showNetworkError(message: String) {
        showLoadingIndicator(shouldShow: true)
        buttonIsEnabled(Bool: false)
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать еще раз",
                                    completion: { [weak self] in
            guard let self else { return }
            self.presenter.restarGame()
        })
        alertPresenter?.showAlert(with: alertModel)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView?.layer.masksToBounds = true
        imageView?.layer.borderWidth = 8
        imageView?.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        buttonIsEnabled(Bool: false)
    }
    
    func turnOffFrame (color:UIColor = UIColor.clear) {
        imageView?.layer.borderColor = color.cgColor
    }
    
    func buttonIsEnabled(Bool: Bool) {
        noAnswerButton.isEnabled = Bool
        yesAnswerButton.isEnabled = Bool
    }
    
    func showLoadingIndicator(shouldShow: Bool) {
        if shouldShow == true {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
