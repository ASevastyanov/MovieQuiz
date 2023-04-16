import Foundation
import UIKit

// MARK: - Структуры приложения

/// Вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    // Картинка с афишей фильма с типом UIImage
    let image: UIImage
    // Вопрос о рейтинге квиза
    let question: String
    // Строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
