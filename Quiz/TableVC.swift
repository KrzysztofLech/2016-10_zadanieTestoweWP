//
//  TableVCTableViewController.swift
//  Quiz
//
//  Created by Black Thunder on 20.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    
    //MARK: - Properties
    //----------------------------------------------------------------------------------------------------------------------
    
    var quizzes: Quizzes?
    var playerData = [PlayerQuiz]()

    
    
    
    //MARK: - View methods
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // odczytujemy dane gracza o wykonanych quizach
        playerData = readPlayerData()
        
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "TableViewCell")
        
        tableView.rowHeight = 240                                                               // wysokość wiersza komórki
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)            // pierwszy wiersz tabeli przesuwamy o 20 punktów w dół - poniżej status bara
    }
    


    
    
    
    // MARK: - Table methods
    //----------------------------------------------------------------------------------------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (quizzes?.count)! }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 240 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let item = (quizzes?.items?[indexPath.row])!
        let resultText = checkPlayerData(quizID: (item.id)!)
        
        cell.configure(for: item, index: indexPath.row, result: resultText)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = storyboard?.instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        
        taskVC.quizID = quizzes?.items?[indexPath.row].id
        taskVC.quizImage = quizzes?.items?[indexPath.row].mainPhoto?.mediumImage
        
        present(taskVC, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Other methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func checkPlayerData(quizID: Int) -> String {
        // odczytujemy dane gracza i sprawdzamy, czy rozwiązywał dany quiz
        // jeśli tak, to pobieramy wynik i przekazujemy stringa z opisem
        var text = "Nie znasz tego quizu!"
        
        //przeszukujemy dane o quizach gracza w poszukiwaniu takiego o podanym ID
        for item in playerData {
            if item.id == quizID {
                if item.completed {
                    text = String(format: "Ostatni wynik: %0.0f%@", item.questionsCompletedPercent, "%")
                } else {
                    if item.questionsCompleted > 4 { text = "Odpowiedziano na \(item.questionsCompleted) pytań" }
                    else if item.questionsCompleted > 1 { text = "Odpowiedziano na \(item.questionsCompleted) pytania" }
                    else if item.questionsCompleted == 1 { text = "Odpowiedziano na 1 pytanie" }
                    else if item.questionsCompleted == 0 { text = "Nie odpowiedziano na żadne pytanie" }
                }
            }
        }
        return text
    }
    
}
