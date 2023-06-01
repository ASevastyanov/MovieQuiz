import Foundation

struct AlertModel {
    ///Текст заголовка алерта
    let title: String
    ///Текст сообщения алерта
    let message: String
    ///Текст для кнопки алерта
    let buttonText: String
    ///Замыкание без параметров для действия по кнопке алерта
    let completion: (() -> Void)?
}
