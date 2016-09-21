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
    
    var categories:     [Categories]?
    var category:       Category?
    var mainPhoto:      MainPhoto?
    
    
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

        if let arrayCategories = json["categories"].array {
            categories = [Categories]()
            for subCategories in arrayCategories {
                categories?.append(Categories(json: subCategories))
            }
        }

        category = Category(json: json["category"])
        mainPhoto = MainPhoto(json: json["mainPhoto"])
    }
    
    func loadImages(size: CGSize) {
        let quizImageURL = mainPhoto?.url
        let imageURL = URL(string: quizImageURL!)
        let data = try! Data(contentsOf: imageURL!)
        let image = UIImage(data: data)!
        
        //print("Pobrano zdjęcie: \(title!)")
        
        let smallImage = image.resizedImageWithBounds(bounds: size)
        let mediumImage = image.resizedImageWithBounds(bounds: CGSize(
            width: size.width * 2,
            height: size.height * 2))

        mainPhoto?.smallImage = smallImage
        mainPhoto?.mediumImage = mediumImage
    }
}



class Categories {
    
    var uid: Double?
    var name: String?
    var type: String?
    
    init(json: JSON) {
        uid = json["uid"].double
        name = json["name"].string
        type = json["type"].string
    }
}



class Category {
    
    var id: Int?
    var name: String?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
    }
}

class MainPhoto {
    
    var author: String?
    var title: String?
    var height: Int?
    var source: String?
    var width: Int?
    var url: String?
    var smallImage: UIImage?
    var mediumImage: UIImage?
    
    init(json: JSON) {
        url = json["url"].string
        height = json["height"].int
        width = json["width"].int
        title = json["title"].string
        source = json["source"].string
        author = json["author"].string
/*
        // pobieranie grafik i ich skalowanie w tle
        let queue = DispatchQueue(label: "image", qos: .background, target: nil)
        queue.async {
            self.smallImage = self.getImage(width: 365, height: 130)
        }
*/
    }
    
    func getImage(imageSize: CGSize) -> UIImage {
        let imageURL = URL(string: url!)
        let data = try! Data(contentsOf: imageURL!)
        let img = UIImage(data: data)!
        let resizedImage = img.resizedImageWithBounds(bounds: CGSize(width: imageSize.width, height: imageSize.height))
        return resizedImage
    }
}


extension UIImage {
    
    // skalowanie grafiki do podanej wielkości
    
    func resizedImageWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

