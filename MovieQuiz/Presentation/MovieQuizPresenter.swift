//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alexandr Seva on 21.06.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService!
    
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var correctAnswers: Int = 0
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator(shouldShow: true)
    }
    
    // MARK: - Methods
    
    func yesButtonClicked() {
        answerCheck(isYes: true)
    }
    
    func noButtonClicked() {
        answerCheck(isYes: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convertQuestions(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuiz(quiz: viewModel)
        }
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
    
    func switchToNextQuestion () {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }
    
    func didLoadDataFromServer() {
        viewController?.showLoadingIndicator(shouldShow: false)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showAlertNetworkError(message: error.localizedDescription)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func makeResultMassage() -> String {
        statisticService?.saveResultRecord(correct: correctAnswers, total: questionsAmount)
        
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("Error massage")
            return ""
        }
        
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) " + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMassage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMassage
    }
    
    // MARK: - Private Methods
    private func addingPoint(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        addingPoint(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.correctAnswers = self.correctAnswers
            self.questionFactory = self.questionFactory
            self.proceedToNextQuestionOrResults()
            self.viewController?.showLoadingIndicator(shouldShow: true)
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            viewController?.showAlertResult()
        } else {
            self.switchToNextQuestion()
        }
    }
    
    private func answerCheck(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
