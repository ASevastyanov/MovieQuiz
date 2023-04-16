import Foundation
import UIKit

///Класс для отображения алерта
class AlertPresenter{
        static func showAlert(from viewController: UIViewController, model: AlertModel) {
            let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
                model.completion?()
            }
            
            alert.addAction(action)
            
            viewController.present(alert, animated: true, completion: nil)
        }
}
