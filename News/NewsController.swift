//
//  ViewController.swift
//  News
//
//  Created by Khoa Nguyen on 3/6/2022.
//

import UIKit

class NewsController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var model = ArticleModel()
    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        // Set the viewcontroller as the datasource and delegate of the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get the articles from the article model
        model.delegate = self
        model.getArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Detect the indexpath the user selected
        let indexPath = tableView.indexPathForSelectedRow
        
        guard indexPath != nil else {
            // The user hasn't selected anything
            return
        }
        
        // Get the article the user tapped on
        let article = articles[indexPath!.row]
        
        // Get a reference to the detail view controller
        let detailVC = segue.destination as! DetailViewController
        
        // Pass the article url to the detail view controller
        detailVC.articleUrl = article.url!
        
    }
    
}
extension NewsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        // Get the article that the tableView is asking about
        let article = articles[indexPath.row]
        
        // Customize it
        cell.displaArticle(article)
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // User has just selected a row, trigger the seque to go to detail
        performSegue(withIdentifier: "goToDetail", sender: self)
        
    }
    
}

extension NewsController:  ArticleModernProtocol{
    
    //MARK: - Article Model Protocol Methods
    
    func articleRetrived(_ article: [Article]) {
        
        // Set the articles property of the view controller to the articless passed back from the model 
        self.articles = article
        
        // Refresh the tableview
        tableView.reloadData()
    }
    
}

