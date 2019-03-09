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


}

