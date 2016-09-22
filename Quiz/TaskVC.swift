//
//  TaskVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var quizQuestionLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var quizProgressBar: UIProgressView!
    @IBOutlet weak var progresBarDoneLabel: UILabel!
    @IBOutlet weak var progresBarAllLabel: UILabel!
    @IBOutlet weak var progresBarPercentLabel: UILabel!
    @IBOutlet weak var positionB4: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var quiz: Quiz?
    
    var quizID: Int!            // identyfikator potrzebny do popbrania danych quizu
    var quizImage: UIImage?     // zdjęcie przekazne z poprzedniego widoku
    
    var playerQuiz: PlayerQuiz!
    //var playerData: [Int: PlayerQuiz]!
    var playerDoneQuestions: Int = 0 // liczba zrealizowanych pytań
    var allQuestionAmount: Int!
    
    
    
    
    
    // MARK: - System Methods
    
    // ukrycie Status Bara
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readPlayerData()    // odczyt danych gracza
        
        readData()      // odczyt danych quizu
        setUpQuiz()     // konfiguracja widoku
        setUpQuestion(questionNumber: playerDoneQuestions)  // konfiguracja widoku dla danego pytania
    }

    // MARK: - Other Methods
    

    
    
    
    func readPlayerData() {
        
        playerQuiz = PlayerQuiz()
        
        readWritedPlayerData()  // odczyt zapisanych danych gracza
        
        playerDoneQuestions = playerQuiz.questionsCompleted
        

/*
        let id = 12345
        let playerQuiz = PlayerQuiz()
        
        playerData[id] = playerQuiz

        if playerData[123454] != nil {
            print(playerData[id]?.questionsCompleted)
        } else {
            print("nie ma")
        }
 */
    }
    
    func readWritedPlayerData() {
        
        let playerData = [Int: PlayerQuiz]()
        
        /// tu metoda odczytu
        
        // sprawdzamy czy ID quizu jest w danych gracza
        // jeśli jest, to uaktualniamy dane quizu
        if let data = playerData[quizID] {
            playerQuiz = data
        }
    }
    
    
    func setUpQuiz() {
        quizImageView.image = quizImage
        allQuestionAmount = (quiz?.questions?.count)!
    }
    
    func setUpQuestion(questionNumber: Int) {
        quizQuestionLabel.text = quiz?.questions?[questionNumber].text
        
        button1.setTitle(quiz?.questions?[questionNumber].answers?[0].text, for: .normal)
        button2.setTitle(quiz?.questions?[questionNumber].answers?[1].text, for: .normal)
        button3.setTitle(quiz?.questions?[questionNumber].answers?[2].text, for: .normal)
        button4.setTitle(quiz?.questions?[questionNumber].answers?[3].text, for: .normal)

        // TODO: ustawić dla napisów przycisków setAttributtedTitle
        
        quizProgressBar.progress = 1.0 / Float(allQuestionAmount) * Float(questionNumber)
        
        progresBarDoneLabel.text = String(playerDoneQuestions)
        progresBarAllLabel.text = String(allQuestionAmount)
        progresBarPercentLabel.text = String(format: "%0.2f %@", playerQuiz.questionsCompletedPercent, "%")
    }
    

    func readData() {
        let urlString = "http://quiz.o2.pl/api/v1/quiz/" + String(describing: quizID!) + "/0"
        let url = URL(string: urlString)
        let jsonString = try! String(contentsOf: url!)
        let jsonData: Data = jsonString.data(using: String.Encoding.utf8)!
        let json = JSON(data: jsonData)
        
        quiz = Quiz(json: json)
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        // sprawdzamy odpowiedź
        let quizAnswer = quiz?.questions?[playerDoneQuestions].answers?[sender.tag - 1].isCorrect
        if quizAnswer != nil {
            answer(true)
        } else {
            answer(false)
        }
    }
    
    func answer(_ answer: Bool) {
        if answer {
            print("Dobrze")
            
            playerQuiz.questionsCompletedPercent += 100 / Float(allQuestionAmount)
        } else {
            print("Źle")
        }
        nextQuestion()
    }

    func nextQuestion() {
        playerDoneQuestions += 1
        
        if playerDoneQuestions == allQuestionAmount {
            quizFinished()
        } else {
            setUpQuestion(questionNumber: playerDoneQuestions)
        }
    }
    

    func quizFinished() {
        print("Koniec")
        
        /// schowaj przyciski
        /// pokaż gratulacje
        /// załaduj kontroler z podsumowaniem
    }
}
