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
        
        // TODO: Refactoring access to word file to better handle error
        // find a file start.txt if existing
        if let startWordPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            // if it has strings inside
            if let startWords = try? String(contentsOfFile: startWordPath) {
                // break them up when you find a return and store them in the array
                allWords = startWords.components(separatedBy: "\n")
                // check if array has been populated
                if allWords.count == 0 {
                    // if not, use default word list
                    loadDefaultWords()
                }
            } else {
                loadDefaultWords()
            }
        } else {
            loadDefaultWords()
        }
        // load the initial game state
        startGame()
    }
    
    // TODO: Create array of words in case retrieving start.txt fails
    func loadDefaultWords() {
        allWords = ["angelica", "botanist", "captured", "dressers", "emphasis", "filtrate"]
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
        
        // initialize array to store error title and message
        var error = [String]()
        
        // if all of the methods are true
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isDifferent(word: lowerAnswer){
                        // insert the word at index 0 of the usedWords array
                        usedWords.insert(answer, at: 0)
                        
                        // set the indexPath to 0, meaning the first cell of the tableView
                        let indexPath = IndexPath(row: 0, section: 0)
                        // insert the item at index 0 in a cell at the top of the table
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        return
                    // handle all cases where there's an error
                    } else {
                        error = showError("startWord")
                    }
                } else {
                    error = showError("notReal")
                }
            } else {
                error = showError("notOriginal")
            }
        } else {
            error = showError("notPossible")
        }
        // create an alert controller that displays the error
        let ac = UIAlertController(title: error[0], message: error[1], preferredStyle: .alert)
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
        // TODO: Prevent the user from inserting empty or short answers
        if word.count <= 2 {
            return false
        }
        // use subclass text checker
        let checker = UITextChecker()
        // check the whole word
        let range = NSMakeRange(0, word.utf16.count)
        // look for misspellings in the input word, from index 0 for english language
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // if you don't find misspellings, return true
        return misspelledRange.location == NSNotFound
    }
    
    // MARK: isDifferent method
    func isDifferent(word: String) -> Bool {
        
        // store the start word
        let tempWord = title?.lowercased()
        
        // TODO: Prevent user from inserting the start word
        if word == tempWord {
            return false
        }
        return true
    }
    
    // TODO: Refactor Error Messages
    func showError(_ error: String) -> [String] {
        var errorMessages = [String]()
        if error == "notReal" {
            errorMessages = ["Word not recognized", "It has to be a real word with at least 3 characters."]
        } else if error == "startWord" {
            errorMessages = ["Same as start word", "You can't input the start word!"]
        } else if error == "notOriginal" {
            errorMessages = ["Word used already", "Be more original!"]
        } else if error == "notPossible" {
            errorMessages = ["Word not possible", "You can't spell that word from '\(title!.lowercased())'!"]
        }
        return errorMessages
    }
    
    
    
}

