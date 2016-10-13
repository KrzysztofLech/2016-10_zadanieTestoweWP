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
    
    var downloadTask: URLSessionDownloadTask?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(for item: Item, index: Int, result: String) {
        
        // ustawiamy zdjęcie
        if let image = item.mainPhoto?.smallImage {
            imageViewCell.image = image                 // jeśli zdjęcie zostało wcześniej pobrane, to pokazujemy je
        } else {
            imageViewCell.image = nil
            //print("brak zdjęcia nr \(index)")
            
            if let urlString = item.mainPhoto?.url {
                let url = URL(string: urlString)!
                downloadTask = imageViewCell.loadImage(url: url, item: item)
            }
        }
        
        // wpisujemy tytuł quizu
        let labelText = String(index + 1) + ". " + (item.title)!
        titleLabel.text = labelText
        
        // podajemy wynik quizu
        resultLabel.text = result
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // wstrzymujemy pobieranie zdjęć do komórek nie wyświetlanych aktualnie
        downloadTask?.cancel()
        downloadTask = nil
    }
}
