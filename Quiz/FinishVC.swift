//
//  FinishVC.swift
//  Quiz
//
//  Created by Black Thunder on 23.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class FinishVC: UIViewController {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    var quiz: Quiz?                             // dane rozwiązywanego quizu
    var playerQuiz: PlayerQuiz!                 // dane gracza dotyczące quizu    
    var quizImage: UIImage?                     // zdjęcie przekazne z poprzedniego widoku
    
    
    
    // MARK: - View Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    // ukrycie Status Bara
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getComment()
        
        let result = playerQuiz.questionsCompletedPercent
        let resultString = String(format: "%0.0f %@", result, "%")
        resultLabel.text = resultString
    }

    // MARK: - Other Methods
    //----------------------------------------------------------------------------------------------------------------------

    func getComment() {
        let playerResult = playerQuiz.questionsCompletedPercent
        
        if let rates = quiz?.rates {
            for rate in rates {
                
                let min = Float(rate.from!)
                let max = Float(rate.to!)
                //print("\(min)-\(max) \(rate.content)")
                
                if (playerResult >= min) && (playerResult <= max) {
                    commentLabel.text = rate.content!
                    //break
                }
            }
        }
    }
    

    @IBAction func repeatSelected(_ sender: AnyObject) {
        
        // usuwamy dotychczasowy wynik quizu
        playerQuiz.completed = false
        playerQuiz.questionsCompleted = 0
        playerQuiz.questionsCompletedPercent = 0.0
        writePlayerData(playerQuiz)     // zapisujemy osiągnięcia gracza
        
        // przechodzimy do widoku odpowiedzi
        let taskVC = storyboard?.instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        taskVC.quizID = quiz?.id!
        taskVC.quizImage = quizImage
        present(taskVC, animated: true, completion: nil)
    }
    
    @IBAction func allSelected(_ sender: AnyObject) {
    }
}
