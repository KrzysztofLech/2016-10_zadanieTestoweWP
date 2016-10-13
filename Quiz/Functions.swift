//
//  Functions.swift
//  Quiz
//
//  Created by Black Thunder on 23.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

// funkcja odczytuje obraz z podanego adresu URL
func readImage(fromURL stringURL: String) -> UIImage {
    let imageURL = URL(string: stringURL)
    let data = try! Data(contentsOf: imageURL!)
    let img = UIImage(data: data)!
    return img
}








// określa ścieżkę do folderu z danymi
func documentsDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
    return paths[0]
}

// podaje ścieżkę do pliku z danymi
func dataFilePath() -> String {
    let fileName = "PlayerQuizData"
    return "\(documentsDirectoryPath())/\(fileName).plist"
}


// pokazuje ścieżkę do folderu z danymi
func showDataFilePath() {
    print("--------------------")
    print("Documents folder is:")
    print(documentsDirectoryPath())
    print("--------------------")
    //print("Data file path is:")
    //print(dataFilePath())
    //print("--------------------")
}






// funkcja odczytuje zapisane dane o postępach gracza
func readPlayerData() -> [PlayerQuiz] {
    
    var playerData = [PlayerQuiz]()
    
    let path = dataFilePath()
    if FileManager.default.fileExists(atPath: path) {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            playerData = unarchiver.decodeObject(forKey: "PlayerData") as! [PlayerQuiz]
            unarchiver.finishDecoding()
        }
    } else {
        print("Nie odnaleziono pliku z danymi!")
    }
    return playerData
}


// funkcja zapisuje dane gracza
func writePlayerData(_ dataToWrite: PlayerQuiz) {
    
    //print("zapisano: id: \(dataToWrite.id), completed: \(dataToWrite.completed), zrobiono pytań: \(dataToWrite.questionsCompleted), procent: \(dataToWrite.questionsCompletedPercent)")
    
    var playerData = [PlayerQuiz]()
    playerData = readPlayerData()
    
    // sprawdzamy, czy dane quizu były już wcześniej zapisane
    // jeśli tak, to uaktualniamy je
    var isDataModified = false
    for item in playerData {
        if item.id == dataToWrite.id {
            item.completed = dataToWrite.completed
            item.questionsCompleted = dataToWrite.questionsCompleted
            item.questionsCompletedPercent = dataToWrite.questionsCompletedPercent
            isDataModified = true
            break
        }
    }
    
    // jeśli zapisujemy dane dotyczące nowego quizu
    if !isDataModified {
        let newItem = PlayerQuiz(
            id: dataToWrite.id,
            completed: dataToWrite.completed,
            questionsCompleted: dataToWrite.questionsCompleted,
            questionsCompletedPercent: dataToWrite.questionsCompletedPercent)
        playerData.append(newItem)
    }
    
    // zapis danych:
    
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    
    archiver.encode(playerData, forKey: "PlayerData")
    
    archiver.finishEncoding()
    data.write(toFile: dataFilePath(), atomically: true)
}


