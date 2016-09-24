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
    let imagesToLoad = 3                // ilość zdjęć wstępnie ładowanych
    var counterLoadedImages = 0         // licznik załadowanych zdjęć

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var button1: Button1!
    @IBOutlet weak var button2: Button2!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var infoLabel: UILabel!

    
    
    // MARK: - View Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        /// sprawdźić połączenie z internetem
        
        //showDataFilePath()
        //utworzPrzykladoweDaneGracza()
        
        
        playerData = readPlayerData()
        
        //print("odczytane dane mają \(playerData.count) pozycji")
        //print("id: \(playerData[0].id) zrobiono pytań: \(playerData[0].questionsCompleted), procent: \(playerData[0].questionsCompletedPercent)")
        
        readData()            // odczyt danych JSON - 100 quizów
        loadFirstImages()     // pobieramy zdjęcia kilku początkowych quizów
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animations1()
    }
    
    // MARK: - Animations
    //----------------------------------------------------------------------------------------------------------------------
    
    func animations1() {
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
            self.logoView.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
                    self.label2.center.x -= self.view.frame.size.width
                    self.label3.center.x += self.view.frame.size.width
                    }, completion: { _ in
                        UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
                            self.background.alpha = 1.0
                            self.label1.textColor = UIColor(red: 255/255, green: 194/255, blue: 0/255, alpha: 1.0)
                            self.label1.center.y -= 220
                            self.label1.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            }, completion: { _ in
                                self.infoLabel.alpha = 1.0
                                while self.counterLoadedImages != self.imagesToLoad {}
                                self.animations2()
                        })
                })
        })
    }
    
    
    func animations2() {
        
        button1.center.x += view.frame.width
        button2.center.x -= view.frame.width
        
        button1.alpha = 1.0
        button2.alpha = 1.0
  
        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1.0,
            options: .curveEaseOut,
            animations: {
                self.label1.alpha = 0.0
                self.button1.center.x -= self.view.frame.width
                self.button2.center.x += self.view.frame.width
            },
            completion: { _ in
                self.label1.alpha = 0.0
                self.infoLabel.text = "Wybierz listę quizów"
        })
    }
    
    
    
    // MARK: - Other Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    
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
        for index in 0...(imagesToLoad - 1) {

            let queue = DispatchQueue(label: "images", qos: .userInitiated, target: nil)
            queue.async {
                self.quizzes?.items?[index].loadImages(size: self.view.frame.size)
                self.counterLoadedImages += 1
                //print("Pobrano zdjęcie \(index)")
            }
        }
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
