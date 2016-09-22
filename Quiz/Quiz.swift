//
//  Quiz.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class Quiz {
    
    var title: String?
    var content: String?
    var image: UIImage?
    
    var id: Int?
    
    var questions: [Questions]?
    var rates: [Rates]?
    
    init(json: JSON) {
        
        title = json["title"].string
        content = json["content"].string
        id = json["id"].int

        if let arr = json["questions"].array{
            questions = [Questions]()
            for subJSON in arr{
                questions?.append(Questions(json: subJSON))
            }
        }

        if let arr = json["rates"].array{
            rates = [Rates]()
            for subJSON in arr{
                rates?.append(Rates(json: subJSON))
            }
        }
    }
}


class Questions {
    
    var text: String?
    //var order: Int?
    var answers: [Answers]?
    //var answer: String?
    //var image: Image?
    //var type: String?
    
    
    init(json: JSON) {
        text = json["text"].string
        //order = json["order"].int
        if let arr = json["answers"].array{
            answers = [Answers]()
            for subJSON in arr{
                answers?.append(Answers(json: subJSON))
            }
        }
        //answer = json["answer"].string
        //image = json["image"].image
        //type = json["type"].string
    }
}


class Answers {
    
    var text: String?
    var order: Int?
    var isCorrect: Int?
    
    
    init(json: JSON) {
        text = json["text"].string
        order = json["order"].int
        isCorrect = json["isCorrect"].int
    }
}


class Rates {

    var from: Int?
    var to: Int?
    var content: String?

    init(json: JSON) {
        from = json["from"].int
        to = json["to"].int
        content = json["content"].string
    }
}

