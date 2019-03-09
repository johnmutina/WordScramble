//
//  ViewController.swift
//  WordScramble
//
//  Created by Fabio on 09/03/2019.
//  Copyright © 2019 JohnMutina. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // initialize two arrays of strings
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add button to have user input a word
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // find a file start.txt if existing
        if let startWordPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            // if it has strings inside
            if let startWords = try? String(contentsOfFile: startWordPath) {
                // break them up when you find a return and store them in the array
                allWords = startWords.components(separatedBy: "\n")
            // otherwise
            } else {
                // use a default parameter
                allWords = ["silkworm"]
            }
        }
        // load the initial game state
        startGame()
    }
    
    // MARK: Define the initial game state
    func startGame() {
        // set view title equals to a random word
        title = allWords.randomElement()
        // empty the usedWords array
        usedWords.removeAll(keepingCapacity: true)
        // reload the tableview data
        tableView.reloadData()
    }
    
    // MARK: Handle table view rows and cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create cells with their identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        // set text equal to the correspondent usedWords element
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // MARK: Prompt for answer function
    @objc func promptForAnswer() {
        // create a new alert controller
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // allow user to input text
        ac.addTextField()
        // add a way to submit the input text
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] _ in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        ac.addAction(submitAction)
        // present the alert controller
        present(ac, animated: true)
    }

    // MARK: Method to submit answer
    func submit(answer: String) {
        // make all answers equal by lowercasing them
        let lowerAnswer = answer.lowercased()
        
        // store error if existing
        let errorTitle: String
        // store error message if existing
        let errorMessage: String
        
        // if all of the methods are true
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    // insert the word at index 0 of the usedWords array
                    usedWords.insert(answer, at: 0)
                    
                    // set the indexPath to 0, meaning the first cell of the tableView
                    let indexPath = IndexPath(row: 0, section: 0)
                    // insert the item at index 0 in a cell at the top of the table
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                // handle all cases where there's an error
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
        }
        // create an alert controller that displays the error
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        // add ok button to allow user to continue
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        // present the alert controller
        present(ac, animated: true)
    }
    
    // check if input is a correct scramble
    func isPossible(word: String) -> Bool {
        // store the word in a variable
        var tempWord = title?.lowercased()
        
        // loop through the letters
        for letter in word {
            // if you find one of the letters of the input word
            if let pos = tempWord?.range(of: String(letter)) {
                // remove it
                tempWord?.remove(at: pos.lowerBound)
            } else {
                // if you don't find it, return false
                return false
            }
        }
        // reachable only if false is never reached
        return true
    }
    
    // check if the world hasn't been used already
    func isOriginal(word: String) -> Bool {
        // if the array contains the word return false (!true)
        return !usedWords.contains(word)
    }
    
    // check if is real English
    func isReal(word: String) -> Bool {
        // use subclass text checker
        let checker = UITextChecker()
        // check the whole word
        let range = NSMakeRange(0, word.utf16.count)
        // look for misspellings in the input word, from index 0 for english language
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // if you don't find misspellings, return true
        return misspelledRange.location == NSNotFound
    }
    
    
}

