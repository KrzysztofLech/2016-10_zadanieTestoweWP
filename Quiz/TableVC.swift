//
//  TableVCTableViewController.swift
//  Quiz
//
//  Created by Black Thunder on 20.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    
    //MARK: - Properties
    
    var quizzes: Quiz?
    
    
    
    //MARK: - System methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    
    
    
    // MARK: - Table methods
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (quizzes?.count)! }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let labelText = String(indexPath.row + 1) + " " + (quizzes?.items?[indexPath.row].title)!
        cell.textLabel?.text = labelText
        
        return cell
    }

    
    
    
    // MARK: - Other methods
    
    func readData() {
        let url = URL(string: "http://quiz.o2.pl/api/v1/quizzes/0/100")
        let jsonString = try! String(contentsOf: url!)
        
        let jsonData: Data = jsonString.data(using: String.Encoding.utf8)!
        let json = JSON(data: jsonData)
        
        quizzes = Quiz(json: json)
    }

    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
