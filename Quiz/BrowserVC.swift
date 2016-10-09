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
    //----------------------------------------------------------------------------------------------------------------------
    
    var quizzes: Quizzes?
    
    var amountAllQuizzes: Int?      // liczba wszystkich quizów
    var counter = 0 {               // licznik pobranych zdjęć
        didSet {
            if counter < amountAllQuizzes! {
                loadQuizImage(counter)
            }
        }
    }

    var pageVC = UIPageViewController()
    var controllers = [UIViewController]()
    var pagesNumber: Int!
    
    var currentPageIndex = 0
    var nextPageIndex = 1
    
    var imageSize: CGSize!
    
    @IBOutlet weak var button: UIButton!

    
    //MARK: - View methods
    //----------------------------------------------------------------------------------------------------------------------
    
    // ukrycie Status Bara
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        counter = 1000      // przechodząc do innego widoku kończymy pobieranie zdjęć
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // określamy wielkość ładowanych zdjęć
        imageSize = view.frame.size
        
        
        // uruchamiamy 4 wątki ładujące w tle zdjęcia quizów
        counter = 3     // zaczynamy od 3, gdyż tyle zdjęć wcześniej pobrano
        //counter += 1
        //counter += 1
        //counter += 1

        pagesNumber = amountAllQuizzes        
        
        // tworzymy pierwsze 3 strony
        for index in 0...2 {
            let vc = viewControllerAtIndex(index)
            controllers.append(vc!)
        }

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
        
        let quizResult = checkPlayerData(quizID: (quizzes?.items?[index].id)!)
        
        pageContentVC.quizTitle = quizTitle
        pageContentVC.quizImage = quizImage
        pageContentVC.quizCategory = quizCategory
        pageContentVC.quizContent = quizContent
        pageContentVC.quizQuestionAmount = quizQuestionAmount
        pageContentVC.quizResult = quizResult
        
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
                
                //let nextImage = quizzes?.items?[newPageIndex].mainPhoto?.mediumImage
                //if nextImage == nil { loadImage(index: newPageIndex) }      // pobieranie kolejnego zdjęcia w tle

                // tworzymy kontroler dla strony 2 pozycje dalej
                let vc = viewControllerAtIndex(newPageIndex)
                controllers.append(vc!)
                //print("Utworzono VC nr \(newPageIndex)")
            }
            else if nextPageIndex < currentPageIndex {
                currentPageIndex -= 1
            }
            //print("Wyświetlono stronę nr: \(currentPageIndex)")
        }
    }

    // MARK: - Other Methods
    //----------------------------------------------------------------------------------------------------------------------
    
    func checkPlayerData(quizID: Int) -> String {
        // odczytujemy dane gracza i sprawdzamy, czy rozwiązywał dany quiz
        // jeśli tak, to pobieramy wynik i przekazujemy stringa z opisem
        var text = "Nie znasz tego quizu!"
        
        var playerData = [PlayerQuiz]()
        playerData = readPlayerData()
        
        //przeszukujemy dane o quizach gracza w poszukiwaniu takiego o podanym ID
        for item in playerData {
            if item.id == quizID {
                if item.completed {
                    text = String(format: "Ostatni wynik: %0.0f%@", item.questionsCompletedPercent, "%")
                } else {
                    if item.questionsCompleted > 4 { text = "Odpowiedziano na \(item.questionsCompleted) pytań" }
                    else if item.questionsCompleted > 1 { text = "Odpowiedziano na \(item.questionsCompleted) pytania" }
                    else if item.questionsCompleted == 1 { text = "Odpowiedziano na 1 pytanie" }
                    else if item.questionsCompleted == 0 { text = "Nie odpowiedziano na żadne pytanie" }
                }
            }
        }
        return text
    }
    
    
    // funkcja pobiera zdjęcia quizów
    func loadQuizImage(_ index: Int) {
        // sprawdzamy, czy zdjęcie nie zostało już wcześniej pobrane
        if quizzes?.items?[index].mainPhoto?.mediumImage == nil {
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                self.quizzes?.items?[index].loadImages(size: self.imageSize)
                print("pobrano zdjęcie quizu nr \(index)")
                
                self.counter += 1
            }
        }
    }
    
    
/*
    func loadImage(index: Int) {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            self.quizzes?.items?[index].loadImages(size: self.imageSize)
            print("pobrano zdjęcie nr \(index)")
        }
    }

*/
 
    @IBAction func buttonSelected(_ sender: UIButton) {
        let taskVC = storyboard?.instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        
        taskVC.quizID = quizzes?.items?[currentPageIndex].id
        taskVC.quizImage = quizzes?.items?[currentPageIndex].mainPhoto?.mediumImage
        
        present(taskVC, animated: true, completion: nil)
    }
    
    
}
