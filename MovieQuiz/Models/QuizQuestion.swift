import Foundation

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