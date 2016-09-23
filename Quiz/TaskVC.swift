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
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    // MARK: - Properties
    
    var quiz: Quiz?
    
    var quizID: Int!                            // identyfikator potrzebny do popbrania danych quizu
    var quizImage: UIImage?                     // zdjęcie przekazne z poprzedniego widoku
    
    var playerQuiz: PlayerQuiz!                 // dane gracza dotyczące quizu
    //var playerData: [Int: PlayerQuiz]!
    var allQuestionAmount: Int!                 // liczba wszystkich pytań w quizie
    var playerDoneQuestions: Int = 0 {          // ile pytań zostało wykonanych
        didSet {
            playerQuiz.questionsCompleted = playerDoneQuestions
        }
    }
    var questionsCompletedPercent: Float = 0.0 {  // ile procent testu zostało wykonane prawidłowo
        didSet {
            playerQuiz.questionsCompletedPercent = questionsCompletedPercent
        }
    }
    var viewWidth: CGFloat!                 // szerokość ekranu
    
    
    // MARK: - System Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    // ukrycie Status Bara
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWidth = view.frame.width        // ustalamy szerokość ekranu
        
        // pokaż przyciski
        for index in 1...4 {
            let button = view.viewWithTag(index) as! UIButton
            
            if index % 2 == 0 {
                button.center.x += viewWidth
            } else {
                button.center.x -= viewWidth
            }
            showButton(button)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readJsonData()                          // odczyt danych quizu
        readPlayerData()                        // odczyt danych gracza

        setUpQuiz()                             // konfiguracja widoku
        setUpQuestion(playerDoneQuestions)      // konfiguracja widoku dla danego pytania
    }

    
    // MARK: - Other Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func showButton(_ button: UIButton) {

        let animationTime = 1.5
        let delayTime = Double(button.tag / 2)
        
        UIView.animate(
            withDuration: animationTime,
            delay: delayTime,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1.0,
            options: .curveEaseOut,
            animations: {
                if button.tag % 2 == 0 {
                    button.center.x -= self.viewWidth
                } else {
                    button.center.x += self.viewWidth
                }
            },
            completion: nil)
    }
    
    
    func readJsonData() {
        let urlString = "http://quiz.o2.pl/api/v1/quiz/" + String(describing: quizID!) + "/0"
        let url = URL(string: urlString)
        let jsonString = try! String(contentsOf: url!)
        let jsonData: Data = jsonString.data(using: String.Encoding.utf8)!
        let json = JSON(data: jsonData)
        
        quiz = Quiz(json: json)
    }

    
    
    func readPlayerData() {
        
        playerQuiz = PlayerQuiz()
        readWritedPlayerData()          // odczyt zapisanych danych gracza
        
        //playerDoneQuestions = playerQuiz.questionsCompleted
        

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
        
        /// tu ma być metoda odczytu
        
        // sprawdzamy czy ID quizu jest w danych gracza
        // jeśli jest, to uaktualniamy dane quizu
        if let data = playerData[quizID] {
            playerQuiz = data
        }
    }
    
    
    func setUpQuiz() {
        quizImageView.image = quizImage                     // wyświetlamy zdjęcie przekazne z poprzedniego widoku
        allQuestionAmount = (quiz?.questions?.count)!
        
        // ustawiamy początkowe wartości progress bara
        quizProgressBar.progress = questionsCompletedPercent / 100
        
        progresBarDoneLabel.text = String(playerDoneQuestions)
        progresBarAllLabel.text = String(allQuestionAmount)
        progresBarPercentLabel.text = String(format: "%0.2f %@", questionsCompletedPercent, "%")

    }
    
    func setUpQuestion(_ questionNumber: Int) {
        quizQuestionLabel.text = quiz?.questions?[questionNumber].text
        
        /// Sprawdzić czy pytanie ma własne zdjęcie, jeśli tak to pobrać je
        

        // ustawiamy napisy na przyciskach i wyłączamy zbędne
        let numberOfAnswers = quiz?.questions?[questionNumber].answers?.count
        for index in 1...4 {
            let button = view.viewWithTag(index) as! UIButton
            
            if index <= numberOfAnswers! {
                button.alpha = 1.0
                button.setTitle(quiz?.questions?[questionNumber].answers?[index - 1].text, for: .normal)
            } else {
                button.alpha = 0.0
            }
        }

        // TODO: ustawić dla napisów przycisków setAttributtedTitle
        
        // uaktualniamy progress bar
        progresBarDoneLabel.text = String(playerDoneQuestions)
        quizProgressBar.progress = questionsCompletedPercent / 100
        progresBarPercentLabel.text = String(format: "%0.2f %@", questionsCompletedPercent, "%")
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

        func showIcon() {
            UIView.animate(withDuration: 0.3, animations: {
                self.iconImageView.alpha = 1.0
                }, completion: { _ in
                    UIView.animate(withDuration: 2.5, animations: {
                        self.iconImageView.alpha = 0.0
                        }, completion: {_ in
                            //self.iconImageView.alpha = 0.0
                    })
            })
        }
        
        if answer {
            print("Dobrze")
            iconImageView.image = #imageLiteral(resourceName: "icon_ok")
            questionsCompletedPercent += 100 / Float(allQuestionAmount)
        } else {
            print("Źle")
            iconImageView.image = #imageLiteral(resourceName: "icon_wrong")
        }
        playerDoneQuestions += 1    // koleny pytanie quizu zrobione
        writePlayerData()           // zapisujemy osiągnięcia gracza
        showIcon()                  // pokazuje ikonę dobrej lub złej odpowiedzi
        
        if playerDoneQuestions == allQuestionAmount {
            quizFinished()
        } else {
            hideButtonsAndQuestion()       // chowamy przyciski i pytanie -> pokazujemy nowe
        }
    }
    

    
    func hideButtonsAndQuestion() {

        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.quizQuestionLabel.center.x += self.viewWidth
            self.button1.center.x -= self.viewWidth
            self.button2.center.x += self.viewWidth
            self.button3.center.x -= self.viewWidth
            self.button4.center.x += self.viewWidth
            }, completion: { _ in
                if self.playerDoneQuestions != self.allQuestionAmount {         // sprawdzamy czy nie było to ostatnie pytanie
                    self.setUpQuestion(self.playerDoneQuestions)
                    UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
                        self.quizQuestionLabel.center.x -= self.viewWidth
                        self.button1.center.x += self.viewWidth
                        self.button2.center.x -= self.viewWidth
                        self.button3.center.x += self.viewWidth
                        self.button4.center.x -= self.viewWidth
                        }, completion: nil)
                } else {
                    // gdy odpowiedziano na ostatnie pytanie
                    // uaktualniamy progress bar
                    self.progresBarDoneLabel.text = String(self.playerDoneQuestions)
                    self.quizProgressBar.progress = self.questionsCompletedPercent / 100
                    self.progresBarPercentLabel.text = String(format: "%0.2f %@", self.questionsCompletedPercent, "%")
                    
                    self.quizQuestionLabel.alpha = 0.0
                    self.button1.alpha = 0.0
                    self.button2.alpha = 0.0
                    self.button3.alpha = 0.0
                    self.button4.alpha = 0.0
                }
        })
    }
 
    
    func quizFinished() {
        hideButtonsAndQuestion()
        
        
        print("Koniec")
        /// załaduj kontroler z podsumowaniem
    }
    
    func writePlayerData() {
        /// zapis danych gracza
    }
    
    
    
}


    /*
     UIView.animate(withDuration: 0.5, animations: {
     self.quizQuestionLabel.center.x += self.viewWidth
     self.button1.center.x -= self.viewWidth
     self.button2.center.x -= self.viewWidth
     self.button3.center.x -= self.viewWidth
     self.button4.center.x -= self.viewWidth
     }, completion: { _ in
     self.quizQuestionLabel.center.x += self.viewWidth
     self.button1.center.x = -self.viewWidth
     self.button2.center.x = -self.viewWidth
     self.button3.center.x = -self.viewWidth
     self.button4.center.x = -self.viewWidth
     
     self.setUpQuestion(self.playerDoneQuestions)      // ustawiamy kolejne pytanie i odpowiedzi
     })
     */
    //button1.layer.position.x = -viewWidth
    //button2.layer.position.x = -viewWidth
    //button3.layer.position.x = -viewWidth
    //button4.layer.position.x = -viewWidth
    /*
     // chowamy przyciski
     let flyRight = CABasicAnimation(keyPath: "position.x")
     flyRight.fromValue = view.center.x
     flyRight.toValue = view.center.x - viewWidth
     flyRight.duration = 0.5
     //flyRight.fillMode = kCAFillModeBoth
     flyRight.autoreverses = true
     
     button1.layer.add(flyRight, forKey: "flyRight")
     //button1.layer.position.x = -viewWidth
     
     button2.layer.add(flyRight, forKey: nil)
     //button2.center.x -= viewWidth
     
     button3.layer.add(flyRight, forKey: nil)
     //button3.center.x -= viewWidth
     
     button4.layer.add(flyRight, forKey: nil)
     //button4.center.x -= viewWidth
     
     
     //chowamy label z pytaniem
     let flyLeft = CABasicAnimation(keyPath: "position.x")
     flyLeft.fromValue = view.center.x
     flyLeft.toValue = view.center.x + viewWidth
     flyLeft.duration = 0.5
     flyLeft.autoreverses = true
     flyLeft.delegate = self
     flyLeft.setValue("animacjaFlyLeft", forKey: "name")
     
     quizQuestionLabel.layer.add(flyLeft, forKey: nil)
     //quizQuestionLabel.center.x += viewWidth
     */


/*
 func animationDidStart(_ anim: CAAnimation) {
 }
 
 func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
 
 if let name = anim.value(forKey: "name") as? String {
 if name == "animacjaFlyLeft" {
 setUpQuestion(self.playerDoneQuestions)      // ustawiamy kolejne pytanie i odpowiedzi
 }
 }
 }
 */


