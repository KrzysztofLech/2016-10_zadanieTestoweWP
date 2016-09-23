//
//  Functions.swift
//  Quiz
//
//  Created by Black Thunder on 23.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit



// funkcja zapisuje dane gracza

func writePlayerData() {
    /// zapis danych gracza
}




// funkcja odczytuje obraz z podanego adresu URL

func loadImage(fromURL stringURL: String) -> UIImage {
    let imageURL = URL(string: stringURL)
    let data = try! Data(contentsOf: imageURL!)
    let img = UIImage(data: data)!
    return img
}
