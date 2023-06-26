import UIKit

final class AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert presenter"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
