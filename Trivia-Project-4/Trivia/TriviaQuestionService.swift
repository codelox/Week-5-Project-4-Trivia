//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Naing Oo Lwin on 3/13/24.
//

import Foundation

class TriviaQuestionService {
    static let shared = TriviaQuestionService()
    
    private init() {}
    
    func fetchTriviaQuestions(withCategory category: String? = nil, difficulty: String? = nil, completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        
        var urlString = "https://opentdb.com/api.php?amount=10"
        
        if let category = category {
            
            urlString += "&category=\(category)"
        }
        if let difficulty = difficulty {
            urlString += "&difficulty=\(difficulty.lowercased())"
            
        }
        
        guard let url = URL(string: urlString) else {
            
            completion(nil, NSError(domain: "URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                
                completion(nil, NSError(domain: "Server", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }
            
          
            guard let data = data else {
                completion(nil, NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    
                    
                    completion(nil, NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
                    return
                }
                
                
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing 'results' key"]))
                    return
                    
                }
                
                
                let triviaQuestions = results.compactMap { result in
                    
                    var triviaQuestion = TriviaQuestion(
                        
                        
                        type: result["type"] as? String ?? "",
                        difficulty: result["difficulty"] as? String ?? "",
                        
                        category: result["category"] as? String ?? "",
                        question: result["question"] as? String ?? "",
                        
                        correct_answer: result["correct_answer"] as? String ?? "",
                        
                        
                        incorrect_answers: result["incorrect_answers"] as? [String] ?? []
                    )
                    triviaQuestion.decodeCategoryHTMLEntities()
                    triviaQuestion.decodeQuestionHTMLEntities()
                    triviaQuestion.decodeCorrectAnswerHTMLEntities()
                    triviaQuestion.decodeIncorrectAnswersHTMLEntities()
                    return triviaQuestion
                }
                
                completion(triviaQuestions, nil)
                
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
