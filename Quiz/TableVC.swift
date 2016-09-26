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
    
    var amountAllQuizzes: Int?      // liczba wszystkich quizów
    var counter = 0 {               // licznik pobranych zdjęć
        didSet {
            if counter < amountAllQuizzes! {
                loadQuizImage(counter)
            }
        }
    }

    
    
    //MARK: - View methods
    //----------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // odczytujemy dane gracza o wykonanych quizach
        playerData = readPlayerData()
        
        // uruchamiamy 4 wątki ładujące w tle zdjęcia quizów
        counter = 3     // zaczynamy od 3, gdyż tyle zdjęć wcześniej pobrano
        counter += 1
        counter += 1
        counter += 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        counter = 1000      // przechodząc do innego widoku kończymy pobieranie zdjęć
    }

    
    
    
    // MARK: - Table methods
    //----------------------------------------------------------------------------------------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (quizzes?.count)! }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 240 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // ustawiamy zdjęcie
        let imageView = cell.viewWithTag(1000) as! UIImageView
        let image = quizzes?.items?[indexPath.row].mainPhoto?.smallImage
        imageView.image = image
        
        // wpisujemy tytuł quizu
        let titleLabel = cell.viewWithTag(1001) as! UILabel
        let labelText = String(indexPath.row + 1) + ". " + (quizzes?.items?[indexPath.row].title)!
        titleLabel.text = labelText
        
        // podajemy wynik quizu
        let resultLabel = cell.viewWithTag(1002) as! UILabel
        let resultText = checkPlayerData(quizID: (quizzes?.items?[indexPath.row].id)!)
        resultLabel.text = resultText

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
    
    
    // funkcja pobiera zdjęcia quizów
    func loadQuizImage(_ index: Int) {
        // sprawdzamy, czy zdjęcie nie zostało już wcześniej pobrane
        if quizzes?.items?[index].mainPhoto?.smallImage == nil {
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                let size = self.view.frame.size
                self.quizzes?.items?[index].loadImages(size: size)
                print("pobrano zdjęcie quizu nr \(index)")
                
                self.counter += 1
            }
        }
    }

    
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
