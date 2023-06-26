//
//  QuestionFactory.swift
//  MovieQuiz

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    enum SetWordsForAnswer {
        case more
        case less
        
        var title: String {
            switch self {
            case .more:
                return "больше"
            case .less:
                return "меньше"
            }
        }
    }
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    [weak self ] in guard let self = self else { return }
                    self.delegate?.didFailToLoadData(with: NetworkClient.NetworkError.codeError)
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomOffset = Int.random(in: 4...9)
            var randomAnswer: SetWordsForAnswer? = [.less, .more].randomElement()
            let text = "Рейтинг этого фильма \(randomAnswer!.title) чем \(randomOffset)?"
            var correctAnswer: Bool = generationCorrectAnswer(answer: randomAnswer,
                                                              rating: rating,
                                                              randomOffset: Float(randomOffset))
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    private func generationCorrectAnswer(answer: QuestionFactory.SetWordsForAnswer?,
                                         rating: Float,
                                         randomOffset: Float) -> Bool {
        var answerReturn = false
        
        switch answer {
        case .more:
            answerReturn = rating > randomOffset
        case .less:
            answerReturn = rating < randomOffset
        default:
            break
        }
        return answerReturn
    }
}
