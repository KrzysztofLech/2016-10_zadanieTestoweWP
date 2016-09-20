//
//  Quiz.swift
//  Quiz
//
//  Created by Black Thunder on 20.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class Quiz {

    var count: Int?
    var items: [Item]?
    
    
    init(json: JSON) {
        
        
        count = json["count"].int
        if let quizArray = json["items"].array {
            items = [Item]()
            for quiz in quizArray {
                items?.append(Item(json: quiz))
            }
        }
    }
}


class Item {
    
    var title:          String?
    
    var id:             Double?
    var sponsored:      Bool?
    var type:           String?
    var shareTitle:     String?
    var buttonStart:    String?
    var questions:      Int?
    var createdAt:      String?
    var content:        String?
    
    //var categories:     [Categories]?
    //var category:       Category?
    //var mainPhoto:      MainPhoto?
    
    
    init(json: JSON) {
        title = json["title"].string
        id = json["id"].double
        sponsored = json["sponsored"].bool
        type = json["type"].string
        shareTitle = json["shareTitle"].string
        buttonStart = json["buttonStart"].string
        questions = json["questions"].int
        createdAt = json["createdAt"].string
        content = json["content"].string
/*
        if let arrayCategories = json["categories"].array {
            categories = [Categories]()
            for subCategories in arrayCategories {
                categories?.append(Categories(json: subCategories))
            }
        }
*/        
        //category = json["category"].category
        //mainPhoto = json["mainPhoto"].mainPhoto
    }
}

class Categories {
    
}

class Category {
    
}

class MainPhoto {
    
}
