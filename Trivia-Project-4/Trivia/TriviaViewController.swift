//
//  ViewController.swift
//  Trivia
//
//  Created by Naing Oo Lwin on 3/13/24.
//

import UIKit

class TriviaViewController: UIViewController {

  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
    
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
    
  var selectedCategory: String?
  var selectedDifficulty: String?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      fetchNewGame()
  }
    
  private func fetchNewGame() {
      TriviaQuestionService.shared.fetchTriviaQuestions(withCategory: selectedCategory, difficulty: selectedDifficulty) { [weak self] questions, error in
          guard let self = self else { return }
          DispatchQueue.main.async {
              if let error = error {
                  // Handle error
                  return
              }
              if let questions = questions {
                  self.questions = questions
                  self.currQuestionIndex = 0
                  self.numCorrectQuestions = 0
                  self.updateQuestion(withQuestionIndex: 0) // Update UI with the first question
              }
          }
      }
  }

    
  @IBAction func resetButtonTapped(_ sender: UIButton) {
      fetchNewGame()
  }
    
  @IBAction func settingsButtonTapped(_ sender: UIButton) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if let settingsViewController = storyboard.instantiateViewController(withIdentifier: "settings_scene") as? SettingsViewController {
          settingsViewController.delegate = self // <- Ensure this line is correctly setting the delegate
          navigationController?.pushViewController(settingsViewController, animated: true)
      }
  }
    
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
      currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
      let question = questions[questionIndex]
      questionLabel.text = question.question
      categoryLabel.text = question.category
        
      // Check if the question type is boolean
      if question.type == "boolean" {
        
          answerButton0.setTitle("True", for: .normal)
          answerButton1.setTitle("False", for: .normal)
          answerButton2.isHidden = true
          answerButton3.isHidden = true
      } else {
        
          let answers = ([question.correct_answer] + question.incorrect_answers).shuffled()
          if answers.count > 0 {
              answerButton0.setTitle(answers[0], for: .normal)
              answerButton0.isHidden = false
          }
          if answers.count > 1 {
              answerButton1.setTitle(answers[1], for: .normal)
              answerButton1.isHidden = false
          }
          if answers.count > 2 {
              answerButton2.setTitle(answers[2], for: .normal)
              answerButton2.isHidden = false
          }
          if answers.count > 3 {
              
              answerButton3.setTitle(answers[3], for: .normal)
              answerButton3.isHidden = false
          }
      }
  }

  private func updateToNextQuestion(answer: String) {
      let isCorrect = isCorrectAnswer(answer)
      let feedbackMessage = isCorrect ? "Correct!" : "Incorrect"
    
      
      showAlert(message: feedbackMessage, completion: {
          if isCorrect {
              self.numCorrectQuestions += 1
          }
          self.currQuestionIndex += 1
          guard self.currQuestionIndex < self.questions.count else {
              self.showFinalScore()
              return
          }
          self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
      })
  }
    
  private func showAlert(message: String, completion: @escaping () -> Void) {
      let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      present(alertController, animated: true, completion: {
          // Automatically dismiss the alert after a short delay
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              alertController.dismiss(animated: true, completion: completion)
          }
      })
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correct_answer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      currQuestionIndex = 0
      numCorrectQuestions = 0
      updateQuestion(withQuestionIndex: currQuestionIndex)
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
      
    gradientLayer.frame = view.bounds
      
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            
                            
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
      
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
      
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

  extension TriviaViewController: SettingsViewControllerDelegate {
      func didSelectCategory(_ category: String, difficulty: String) {
          selectedCategory = category
          selectedDifficulty = difficulty
          fetchNewGame()
      }
}
