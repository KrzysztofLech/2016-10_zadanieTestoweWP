//
//  FirstVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    var playerData = [PlayerQuiz]()
    var quizzes: Quizzes?


    
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// sprawdź połączenie z internetem
        
        //showDataFilePath()
        //utworzPrzykladoweDaneGracza()
        
        
        playerData = readPlayerData()
        print("odczytane dane mają \(playerData.count) pozycji")
        //print("id: \(playerData[0].id) zrobiono pytań: \(playerData[0].questionsCompleted), procent: \(playerData[0].questionsCompletedPercent)")
        
        readData()            // odczyt danych JSON - 100 quizów
        loadFirstImages()     // pobieramy zdjęcia kilku początkowych quizów
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    /// Tworze przykładowe dane gracza
    func utworzPrzykladoweDaneGracza() {
        
        
        let wpis1 = PlayerQuiz(
            id: 6040449124353153,
            completed: false,
            questionsCompleted: 3,
            questionsCompletedPercent: 50.0)
        playerData.append(wpis1)
        writePlayerData(wpis1)

    }
    
    
    
    
    // MARK: - Other Methods
    
    
    // odczyt danych JSON - 100 quizów
    func readData() {
        let url = URL(string: "http://quiz.o2.pl/api/v1/quizzes/0/100")
        let jsonString = try! String(contentsOf: url!)
        
        let jsonData: Data = jsonString.data(using: String.Encoding.utf8)!
        let json = JSON(data: jsonData)
        
        quizzes = Quizzes(json: json)
        
        //print("Załadowano dane")
    }
    
    
    // pobieramy zdjęcia kilku początkowych quizów
    func loadFirstImages() {
        for index in 0...2 {
/*
            let queue = DispatchQueue(label: "images", qos: .background, target: nil)
            queue.async {
                self.quizzes?.items?[index].loadImages(size: self.view.frame.size)
                print("Pobrano zdjęcie \(index)")
            }
 */
         quizzes?.items?[index].loadImages(size: self.view.frame.size)
        }
        print("3 pierwsze zdjęcia pobrane!!!!")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableSegue" {
            let controler = segue.destination as! TableVC
            controler.quizzes = quizzes
        }

        else if segue.identifier == "browserSegue" {
            let controler = segue.destination as! BrowserVC
            controler.quizzes = quizzes
        }

    }
    
    
}
