//
//  TableViewCell.swift
//  Quiz
//
//  Created by Black Thunder on 12.10.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(for item: Item, index: Int, result: String) {
        
        // ustawiamy zdjęcie
        let image = item.mainPhoto?.smallImage
        imageViewCell.image = image
        
        // wpisujemy tytuł quizu
        let labelText = String(index + 1) + ". " + (item.title)!
        titleLabel.text = labelText
        
        // podajemy wynik quizu
        resultLabel.text = result
    }
}
