//
//  BrowserContentVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class BrowserContentVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var quizTitle: String!
    var quizImage: UIImage!
    var quizContent: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = quizImage
        titleLabel.text = quizTitle
        
        contentLabel.textColor = UIColor.white
        contentLabel.text = quizContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shadowOpacity = 0.5
    }
}
