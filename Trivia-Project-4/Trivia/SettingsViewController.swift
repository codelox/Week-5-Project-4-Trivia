//
//  SettingsViewController.swift
//  Trivia
//
//  Created by Naing Oo Lwin on 3/15/24.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didSelectCategory(_ category: String, difficulty: String)
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var difficultyButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    let categories: [(name: String, id: Int)] = [
        ("General Knowledge", 9),
        ("Entertainment: Books", 10),
        ("Entertainment: Film", 11),
        ("Entertainment: Music", 12),
        ("Entertainment: Musical & Theatres", 13),
        ("Entertainment: Television", 14),
        ("Entertainment: Video Games", 15),
        ("Entertainment: Board Games", 16),
        ("Science & Nature", 17),
        ("Science: Computers", 18),
        ("Science: Mathematics", 19),
        ("Mythology", 20),
        ("Sports", 21),
        ("Geography", 22),
        ("History", 23),
        ("Politics", 24),
        ("Art", 25),
        ("Celebrities", 26),
        ("Animals", 27),
        ("Vehicles", 28),
        ("Entertainment: Comics", 29),
        ("Science: Gadgets", 30),
        ("Entertainment: Japanese Anime & Manga", 31),
        ("Entertainment: Cartoon & Animations", 32)
    ]
    
    var difficulties = ["easy", "medium", "hard"]
    
    var defaultCategory = "General Knowledge" // Set default category
    var defaultDifficulty = "easy" // Set default difficulty

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default values for buttons
        categoryButton.setTitle(defaultCategory, for: .normal)
        difficultyButton.setTitle(defaultDifficulty, for: .normal)
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let categoryNames = categories.map { $0.name } // Extracting only the names from the array of tuples
        presentSelectionOptions(options: categoryNames) { [weak self] selectedCategory in
            self?.categoryButton.setTitle(selectedCategory, for: .normal)
        }
    }
    
    @IBAction func difficultyButtonTapped(_ sender: UIButton) {
        presentSelectionOptions(options: difficulties) { [weak self] selectedDifficulty in
            self?.difficultyButton.setTitle(selectedDifficulty, for: .normal)
        }
    }
    
    private func presentSelectionOptions(options: [String], completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            let action = UIAlertAction(title: option, style: .default) { _ in
                completionHandler(option)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // In SettingsViewController
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let selectedCategory = categoryButton.title(for: .normal) ?? defaultCategory
        let selectedDifficulty = difficultyButton.title(for: .normal) ?? defaultDifficulty

        print("Selected category: \(selectedCategory), Selected difficulty: \(selectedDifficulty)") // Debugging statement

        delegate?.didSelectCategory(selectedCategory, difficulty: selectedDifficulty)
        dismiss(animated: true, completion: nil)
    }

}

