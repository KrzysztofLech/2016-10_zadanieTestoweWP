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
    
    var quizTitle: String!
    var quizImage: UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = quizTitle
        imageView.image = quizImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shadowOpacity = 0.5
    }
}
