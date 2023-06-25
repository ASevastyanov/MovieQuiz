//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Alexandr Seva on 25.06.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuiz(quiz step: QuizStepViewModel)
    func showAlertResult()
    func showNetworkError(message: String)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator(shouldShow: Bool)
}
