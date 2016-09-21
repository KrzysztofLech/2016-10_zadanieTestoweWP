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
        
        loadAllImages()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    
    
    
    // MARK: - Table methods
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (quizzes?.count)! }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 250 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1000) as! UIImageView
        let image = quizzes?.items?[indexPath.row].mainPhoto?.smallImage
        imageView.image = image
        
        let label = cell.viewWithTag(1001) as! UILabel
        let labelText = String(indexPath.row + 1) + " " + (quizzes?.items?[indexPath.row].title)!
        label.text = labelText

        return cell
    }
    
    
    // MARK: - Other methods
    
    func loadAllImages() {
        
        let itemsNumber = quizzes?.count
        let size = view.frame.size
        for index in 3..<itemsNumber! {
            
            let queue = DispatchQueue(label: "image", qos: .background, target: nil)
            queue.async {
                self.quizzes?.items?[index].loadImages(size: size)

                print(index)
            }
        }
    }



    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
