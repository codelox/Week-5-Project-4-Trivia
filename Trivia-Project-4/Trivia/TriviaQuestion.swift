//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Decodable {
    let type: String
    let difficulty: String
    var category: String // Change to var to allow modification
    var question: String
    var correct_answer: String
    var incorrect_answers: [String] // Change to var to allow modification

    private enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question, correct_answer, incorrect_answers
    }

    // Mutating method to decode HTML entities in category
    mutating func decodeCategoryHTMLEntities() {
        self.category = self.category.replacingOccurrences(of: "&amp;", with: "&")
    }
    
    // Mutating method to decode HTML entities in question
    mutating func decodeQuestionHTMLEntities() {
        self.question = self.question.replacingOccurrences(of: "&quot;", with: "\"")
        self.question = self.question.replacingOccurrences(of: "&#039;", with: "\'")
    }
    
    // Mutating method to decode HTML entities in correct answer
    mutating func decodeCorrectAnswerHTMLEntities() {
        self.correct_answer = self.correct_answer.replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#039;", with: "\'")
    }
    
    // Mutating method to decode HTML entities in incorrect answers
    mutating func decodeIncorrectAnswersHTMLEntities() {
        self.incorrect_answers = self.incorrect_answers.map { $0
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#039;", with: "\'")
        }
    }
}
