//
//  FirstVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    
    var quizzes: Quizzes?
    var firstItem = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        readData()
        loadFirstImages()
    }

    
    func readData() {
        let url = URL(string: "http://quiz.o2.pl/api/v1/quizzes/0/100")
        let jsonString = try! String(contentsOf: url!)
        
        let jsonData: Data = jsonString.data(using: String.Encoding.utf8)!
        let json = JSON(data: jsonData)
        
        quizzes = Quizzes(json: json)
        
        //print("Załadowano dane")
    }
    
    func loadFirstImages() {
        
        // pobieramy zdjęcia kilku początkowych quizów
        
        for index in firstItem ... (firstItem + 2) {
            
            let queue = DispatchQueue(label: "images", qos: .background, target: nil)
            queue.async {
                self.quizzes?.items?[index].loadImages(size: self.view.frame.size)
                print("Pobrano zdjęcie \(index)")
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
