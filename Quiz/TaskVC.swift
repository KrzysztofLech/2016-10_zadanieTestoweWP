//
//  TaskVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {

    var quizID: Double?
    var quizTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Wybrano quiz z ID: \(quizID!)")
        print("Title: \(quizTitle!)")
    }



}
