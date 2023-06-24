//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alexandr Seva on 21.06.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex = 0
    let questionsAmount = 10
    weak var viewController: MovieQuizViewController?
    var currentQuestion: QuizQuestion?
    
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func convertQuestions(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func isLastQuestion () -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion () {
        currentQuestionIndex += 1
    }
}
