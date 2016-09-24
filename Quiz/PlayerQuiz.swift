//
//  Person.swift
//  Quiz
//
//  Created by Black Thunder on 24.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class PlayerQuiz: NSObject, NSCoding {
    
    var id: Int
    var completed: Bool
    var questionsCompleted: Int
    var questionsCompletedPercent: Float
    
    
    init(id: Int, completed: Bool, questionsCompleted: Int, questionsCompletedPercent: Float) {
        self.id = id
        self.completed = completed
        self.questionsCompleted = questionsCompleted
        self.questionsCompletedPercent = questionsCompletedPercent
    }
    
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        completed = aDecoder.decodeBool(forKey: "completed")
        questionsCompleted = aDecoder.decodeInteger(forKey: "questionsCompleted")
        questionsCompletedPercent = aDecoder.decodeFloat(forKey: "questionsCompletedPercent")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(completed, forKey: "completed")
        aCoder.encode(questionsCompleted, forKey: "questionsCompleted")
        aCoder.encode(questionsCompletedPercent, forKey: "questionsCompletedPercent")
    }
}
