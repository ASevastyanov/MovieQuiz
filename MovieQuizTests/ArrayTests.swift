//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Alexandr Seva on 16.06.2023.
//

import XCTest
@testable import MovieQuiz

class ArrayTeasts: XCTest {
    func testGetValueInRange () throws {
        let array = [1,1,2,3,5]
        
        let value = array[safe: 2]
        
        XCTAssertNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1,1,2,3,5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
        
    }
}
