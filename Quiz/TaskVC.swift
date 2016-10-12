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
    //----------------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var quizQuestionNumber: UILabel!
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
    //----------------------------------------------------------------------------------------------------------------------
    
    var quiz: Quiz?                             // parametry quizu odczytane z JSON'a
    
    var quizID: Int!                            // identyfikator potrzebny do popbrania danych quizu
    var quizImage: UIImage?                     // zdjęcie przekazne z poprzedniego widoku
    
    var playerQuiz: PlayerQuiz!                 // dane gracza dotyczące aktualnego quizu
    
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

    
    
    // MARK: - View Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    // ukrycie Status Bara
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJsonData()                          // odczyt danych quizu
        createPlayerQuizData()                  // tworzymy początkowe osiągnięcia gracza w bieżącym quizie
        getPlayerData()                         // odczyt danych gracza
        
        setUpQuestion(playerDoneQuestions)      // konfiguracja widoku dla danego pytania
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWidth = view.frame.width        // ustalamy szerokość ekranu
        quizImageView.image = quizImage     // wyświetlamy zdjęcie przekazne z poprzedniego widoku
        
        // pokaż przyciski
        for index in 1...4 {
            let button = view.viewWithTag(index) as! UIButton
            
            if index % 2 == 0 {
                button.center.x += viewWidth
            } else {
                button.center.x -= viewWidth
            }
            showButton(button)
            scaleImageAnimation()
        }
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
    
    
    func scaleImageAnimation() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.00
        scale.toValue = 2.0
        scale.duration = 20.0
        scale.repeatCount = Float.infinity
        scale.autoreverses = true
        
        quizImageView.layer.add(scale, forKey: nil)
    }
    
    
    func readJsonData() {
        let urlString = "http://quiz.o2.pl/api/v1/quiz/" + String(describing: quizID!) + "/0"
        let url = URL(string: urlString)
        
        if let jsonString = try? String(contentsOf: url!) {
            let jsonData: Data = jsonString.data(using: String.Encoding.utf8)!
            let json = JSON(data: jsonData)
            
            quiz = Quiz(json: json)
        }
    }

    
    func createPlayerQuizData() {
        playerQuiz = PlayerQuiz(
            id: quizID,
            completed: false,
            questionsCompleted: 0,
            questionsCompletedPercent: 0.0)
    }
    
    
    func getPlayerData() {
        // odczytujemy dane gracza i sprawdzamy, czy rozwiązywał bieżący quiz
        // jeśli tak, to uaktualniamy dane quizu po to, aby kontynuować od ostatnio zakończonego pytania
        var playerData = [PlayerQuiz]()
        playerData = readPlayerData()
        
        for item in playerData {
            if item.id == quizID {
                playerDoneQuestions = item.questionsCompleted
                questionsCompletedPercent = item.questionsCompletedPercent
                if item.completed == true { questionsCompletedPercent = 0.0 }   // jeśli rozwiązujemy ponownie od początku
            }
        }
    }
    
    

    
    func setUpQuestion(_ questionNumber: Int) {
        allQuestionAmount = (quiz?.questions?.count)!
        
        // uaktualniamy progress bar
        progresBarDoneLabel.text = String(playerDoneQuestions)
        progresBarAllLabel.text = String(allQuestionAmount)
        quizProgressBar.progress = questionsCompletedPercent / 100
        progresBarPercentLabel.text = String(format: "%0.2f %@", questionsCompletedPercent, "%")
        
        // sprawdzamy, czy pytanie ma własne zdjęcie, jeśli tak to ładujemy je
        let questionImageURL = quiz?.questions?[questionNumber].image?.url
        if questionImageURL != nil && questionImageURL != ""  {
            quizImageView.image = readImage(fromURL: questionImageURL!)
            scaleImageAnimation()
        }
        
        quizQuestionNumber.text = String(format: "Pytanie %i", playerDoneQuestions + 1)
        quizQuestionLabel.text = quiz?.questions?[questionNumber].text
        
        // ustawiamy napisy na przyciskach i wyłączamy zbędne
        let numberOfAnswers = quiz?.questions?[questionNumber].answers?.count
        for index in 1...4 {
            let button = view.viewWithTag(index) as! UIButton
            
            if index <= numberOfAnswers! {
                button.alpha = 1.0
                
                let text = quiz?.questions?[questionNumber].answers?[index - 1].text
                
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                
                let attributedString = NSAttributedString(
                    string: text!,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 15.0),
                        NSForegroundColorAttributeName: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1),
                        NSParagraphStyleAttributeName: style
                    ])
                button.setAttributedTitle(attributedString, for: .normal)
                
            } else {
                button.alpha = 0.0
            }
        }
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
                        }, completion: {_ in            // jeśli to było ostatnie pytanie, to kończymy i przechodzimy do planszy podsumowującej
                            if self.playerDoneQuestions == self.allQuestionAmount {
                                self.showFinish()
                            }
                    })
            })
        }
        
        if answer {     // jeśli odpowiedź była dobra
            iconImageView.image = #imageLiteral(resourceName: "icon_ok")
            questionsCompletedPercent += 100 / Float(allQuestionAmount)
        } else {        // jeśli odpowiedź była zła
            iconImageView.image = #imageLiteral(resourceName: "icon_wrong")
        }
        playerDoneQuestions += 1    // koleny pytanie quizu zrobione
        
        writePlayerData(playerQuiz) // zapisujemy osiągnięcia gracza
        showIcon()                  // pokazuje ikonę dobrej lub złej odpowiedzi
        hideButtonsAndQuestion()    // chowamy przyciski i pytanie -> pokazujemy nowe lub kończymy quiz
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
     
    
    func showFinish() {
        
        playerQuiz.completed = true     // zapisujemy informację o ukończeniu quizu
        playerQuiz.questionsCompleted = 0   // ustawiamy na 0, aby można rozpocząć quiz od początku
        writePlayerData(playerQuiz)     // zapisujemy osiągnięcia gracza
        
        let finishVC = storyboard?.instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
        finishVC.quiz = quiz
        finishVC.playerQuiz = playerQuiz
        finishVC.quizImage = quizImage
        present(finishVC, animated: true, completion: nil)
    }

}
