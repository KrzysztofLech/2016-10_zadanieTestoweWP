//
//  BrowserVC.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class BrowserVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: - Properties
    
    var quizzes: Quizzes?

    var pageVC = UIPageViewController()
    var controllers = [UIViewController]()
    var pagesNumber: Int!
    
    var currentPageIndex = 0
    var nextPageIndex = 1
    
    var imageSize: CGSize!
    
    @IBOutlet weak var button: UIButton!

    
    //MARK: - System methods
    //----------------------------------------------------------------------------------------------------------------------
    
    // ukrycie Status Bara
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        pagesNumber = quizzes?.items?.count

        
        // tworzymy pierwsze 3 strony
        for index in 0...2 {
            let vc = viewControllerAtIndex(index)
            controllers.append(vc!)
        }
        
        // określamy wielkość ładowanych zdjęć
        imageSize = view.frame.size
        

        // ustawiamy parametry Page Controller i pierwszą stronę do wyświetlenia
        pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        pageVC.dataSource = self
        pageVC.delegate = self

        pageVC.setViewControllers(
            [controllers[0]],
            direction: .forward,
            animated: true,
            completion: nil)
        
        
        // dodajemy Page View Controller do superview
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
        //pageVC.didMove(toParentViewController: self)
        
        
        // przenosimy obiekty tego widoku ponad Page Controlera
        view.insertSubview(button, aboveSubview: pageVC.view)
    }
    
    
    
    // MARK: - Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func viewControllerAtIndex(_ index: Int) -> BrowserContentVC! {
        
        if (pagesNumber == 0 || index >= pagesNumber) { return nil }
        let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "BrowserContentVC") as! BrowserContentVC
        
        // przekaznie danych quizu do kontentu
        
        let quizTitle = quizzes?.items?[index].title
        
        let quizImage: UIImage
        let image = quizzes?.items?[index].mainPhoto?.mediumImage
        // sprawdzenie czy zdjęcie jest już załadowane, jeśli nie, to ładujemy je
        if image == nil {
            quizzes?.items?[index].loadImages(size: imageSize)
        }
        quizImage = (quizzes?.items?[index].mainPhoto?.mediumImage)!
        
        let quizCategory: String
        let category1 = (quizzes?.items?[index].categories?[0].name)!
        let category2 = (quizzes?.items?[index].category?.name)!
        quizCategory = category1 + " / " + category2
        
        let quizContent = quizzes?.items?[index].content
        let quizQuestionAmount = quizzes?.items?[index].questions
        
        pageContentVC.quizTitle = quizTitle
        pageContentVC.quizImage = quizImage
        pageContentVC.quizCategory = quizCategory
        pageContentVC.quizContent = quizContent
        pageContentVC.quizQuestionAmount = quizQuestionAmount
        
        return pageContentVC
    }
    
    
    
    
    // MARK: - DataSource methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index > 0 { return controllers[index - 1] }
            else { return nil }
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {

            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
            else { return nil }
        }
        return nil
    }
    
    
    
    
    
    // MARK: - Delegate methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        nextPageIndex = controllers.index(of: pendingViewControllers[0])!
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {

            if nextPageIndex > currentPageIndex {
                currentPageIndex += 1
                
                // ładujemy kolejne zdjęcie do kontrolera 2 pozycje dalej
                let newPageIndex = currentPageIndex + 2
                let nextImage = quizzes?.items?[newPageIndex].mainPhoto?.mediumImage
                if nextImage == nil {
                    // pobieranie kolejnego zdjęcia w tle
                    loadImage(index: newPageIndex)
                }
                
                // tworzymy kontroler dla strony 2 pozycje dalej
                let vc = viewControllerAtIndex(newPageIndex)
                controllers.append(vc!)
                print("Utworzono VC nr \(newPageIndex)")
            }
            else if nextPageIndex < currentPageIndex {
                currentPageIndex -= 1
            }
            //print("Wyświetlono stronę nr: \(currentPageIndex)")
        }
    }

    // MARK: - Other Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func loadImage(index: Int) {
        let queue = DispatchQueue(label: "image", qos: .background, target: nil)
        queue.async {
            self.quizzes?.items?[index].loadImages(size: self.imageSize)
        }
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        let taskVC = storyboard?.instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        
        taskVC.quizID = quizzes?.items?[currentPageIndex].id
        taskVC.quizImage = quizzes?.items?[currentPageIndex].mainPhoto?.mediumImage
        
        present(taskVC, animated: true, completion: nil)
    }
    
    
}
