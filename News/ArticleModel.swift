//
//  ArticleModel.swift
//  News
//
//  Created by Khoa Nguyen on 3/6/2022.
//

import Foundation

protocol ArticleModernProtocol {
    
    func articleRetrived(_ article:[Article])
}

class ArticleModel {
    
    var delegate:ArticleModernProtocol?
    
    func getArticles(){
        
        // Fire off the request to the API
        
        // Create a string URL
        let stringUrl = "https://newsapi.org/v2/everything?q=tree&apiKey=a55901b3a2a64d83beac49ea7846248d"
        
        // Create a URL object
        let url = URL(string: stringUrl)
      
        // Check that it isn't a nil
        guard url != nil else {
            print("Coudn't create url object")
            return
        }
       
        // Get the URL Session
        let session = URLSession.shared
        
        // Create the data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            // Check that there are no errors and that there is data
            if error == nil && data != nil {
                
                // Attempt to parse the JSON
                let decoder = JSONDecoder()
                
                do{
                    
                    // Parse the json into ArticleService
                    let articleService = try decoder.decode(ArticleService.self, from: data!)
                    
                    // Get the articles
                    let articles = articleService.articles!
                    
                    // Pass it back to the view controller in the main thread
                    DispatchQueue.main.async {
                        self.delegate?.articleRetrived(articles)
                    }
                    
                }
                catch{
                    
                    print("error parsing the json")
                    
                } // End Do - Catch
                
            } // End if
            
        } // End Data Task 
       
        
        // Start the data task
        dataTask.resume()
        
        
        
        
    }
}
