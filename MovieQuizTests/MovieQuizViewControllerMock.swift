//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Alexandr Seva on 25.06.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuiz(quiz step: MovieQuiz.QuizStepViewModel) {}
    func showAlertResult() {}
    func showAlertNetworkError(message: String) {}
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func showLoadingIndicator(shouldShow: Bool) {}
}

final class MOvieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convertQuestions(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        
    }
}
