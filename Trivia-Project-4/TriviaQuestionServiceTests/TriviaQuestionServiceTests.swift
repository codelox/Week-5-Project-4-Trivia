//
//  TriviaQuestionServiceTests.swift
//  TriviaQuestionServiceTests
//
//  Created by Naing Oo Lwin on 3/19/24.
//

import XCTest
@testable import Trivia // Import your app module

class TriviaQuestionServiceTests: XCTestCase {

    func testFetchTriviaQuestionsWithCategoryAndDifficulty() {
        // Prepare the service
        let service = TriviaQuestionService.shared
        
        // Define expectations
        let expectation = self.expectation(description: "API fetch completed")
        
        // Call the fetchTriviaQuestions method with category and difficulty
        service.fetchTriviaQuestions(withCategory: "32", difficulty: "easy") { questions, error in
            // Verify if API fetch is successful
            XCTAssertNotNil(questions)
            XCTAssertNil(error)
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
    }
}
