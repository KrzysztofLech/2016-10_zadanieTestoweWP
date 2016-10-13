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
    var counterLoadedImages = 0         // licznik załadowanych wstępnie zdjęć
    var isDataLoaded = false            // czy dane JSON zostały pobrane

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var button1: Button1!
    @IBOutlet weak var button2: Button2!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    var counter: Int = 0 {              // licznik pobieranych zdjęć
        didSet {
            let fractionalProgress: Float = Float(counter) / 100.0
            
            DispatchQueue.main.async { [unowned self] in
                self.progressView.setProgress(fractionalProgress, animated: true)
            }
            //print(fractionalProgress)
        }
    }
    
    
    // MARK: - View Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerData = readPlayerData()
        //showDataFilePath()
        readData()                              // odczyt danych JSON - 100 quizów
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        button1.alpha = 0.0
        button2.alpha = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isDataLoaded { start() }
    }
    
    
    func start() {
        loadFirstImages()     // pobieramy zdjęcia kilku początkowych quizów
        
        if background.alpha == 0 {
            animations1()         // jeśli dane zostały pobrane uruchamiamy animację 1
        } else {
            animations2()         // jeśli wróciliśmy z innego widoku to uruchamiamy animację 2
        }
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
                self.button3.alpha = 1.0
            },
            completion: { _ in
                self.label1.alpha = 0.0
                self.infoLabel.text = "Wybierz sposób wyświetlenia quizów"
        })
    }
    
    
    
    // MARK: - Other Methods
    //----------------------------------------------------------------------------------------------------------------------

    // odczyt danych JSON - paczki 100 quizów
    func readData() {
        let url = URL(string: "http://quiz.o2.pl/api/v1/quizzes/0/100")!
        let sessionn = URLSession.shared
        let dataTask = sessionn.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                self.showError()
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let jsonData: Data = data {
                    let json = JSON(data: jsonData)
                    self.quizzes = Quizzes(json: json)
                    self.isDataLoaded = true
                    //print("Załadowano dane")
                    DispatchQueue.main.async { self.start() }
                }
            } else {
                print("Failure! \(response)")
            }
        })
        dataTask.resume()
    }

    
    
    // pobieramy zdjęcia kilku początkowych quizów
    func loadFirstImages() {
        for index in 0...(imagesToLoad - 1) {
            // sprawdzamy, czy zdjęcie nie zostało już wcześniej pobrane
            if quizzes?.items?[index].mainPhoto?.smallImage == nil {
                DispatchQueue.global(qos: .background).async {
                    self.quizzes?.items?[index].loadImages()
                    self.counterLoadedImages += 1
                    print("Pobrano zdjęcie \(index)")
                }
            }
        }
    }
    
    
    func showError() {
        let ac = UIAlertController(
            title: "Problem z Internetem!",
            message: "Pojawił się problem podczas pobierania danych.",
            preferredStyle: .alert)
        ac.addAction(UIAlertAction(
            title: "Spróbuj ponownie",
            style: .default,
            handler: {_ in
                self.readData()
                if self.isDataLoaded { self.start() }
        }))
        present(ac, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "tableSegue" {
            let controler = segue.destination as! TableVC
            controler.quizzes = quizzes
        }

        else if segue.identifier == "browserSegue" {
            let controler = segue.destination as! BrowserVC
            controler.quizzes = quizzes
            controler.amountAllQuizzes = quizzes?.count
        }
    }
    
    @IBAction func loadDataButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.progressView.alpha = 1.0
            }, completion: { _ in
                self.loadAllPhotos()
        })
    }
    
    
    // pobieramy zdjęcia wszystkich quizów
    func loadAllPhotos() {
        counter = imagesToLoad
        for index in imagesToLoad..<(quizzes?.count)! {
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                self.quizzes?.items?[index].loadImages()
                self.counter += 1
            }
        }
    }
    
    // ustalamy miejsce powrotu
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        //print("Unwind to Root View Controller")
    }

 
}
