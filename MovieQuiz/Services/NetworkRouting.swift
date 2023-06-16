//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Alexandr Seva on 16.06.2023.
//

import Foundation
protocol NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler @escaping (Result<Data, Error>) -> Void) {
        le
    }
}
