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
                }
            }
        }
    }
    
    func isPossible(word: String) -> Bool {
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return true
    }
    
    func isReal(word: String) -> Bool {
        return true
    }
    
    
}

