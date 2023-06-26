//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Alexandr Seva on 16.06.2023.
//

import XCTest
@testable import MovieQuiz

final class ArrayTeasts: XCTest {
    
    private let array = [1,2,3,4,5]
    
    func testGetValueInRange () throws {
        let value = array[safe: 2]
        
        XCTAssertNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        let value = array[safe: 20]
        
        XCTAssertNil(value)
        
    }
}
