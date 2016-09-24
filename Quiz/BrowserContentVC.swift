//
//  BrowserContentVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class BrowserContentVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var questionsLabel: UILabel!
    
    var quizTitle: String!
    var quizImage: UIImage!
    var quizCategory: String!
    var quizContent: String!
    var quizResult: String!
    var quizQuestionAmount: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = quizTitle
        imageView.image = quizImage
        categoryLabel.text = quizCategory
        contentLabel.text = quizContent
        resultLabel.text = quizResult
        questionsLabel.text = "Liczba pytań: \(quizQuestionAmount!)"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shadowOpacity = 0.5
    }
}
