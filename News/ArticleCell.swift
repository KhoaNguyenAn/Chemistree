//
//  ArticleCell.swift
//  News
//
//  Created by Khoa Nguyen on 3/6/2022.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    var articleToDisplay:Article?
    
    func displaArticle(_ article:Article) {
        
      // Clean up the cell before displaying the next article
        articleImageView.image = nil
        articleImageView.alpha = 0
        headlineLabel.text = ""
        headlineLabel.alpha = 0
        
        // Keep a reference to the article
        articleToDisplay = article
        
        // Set the headline
        headlineLabel.text = articleToDisplay!.title
        
        // Animated the label into view
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            
            self.headlineLabel.alpha = 1
            
        }, completion: nil)
            
            
        // Download and display the image
        
        // Check the article actually has an image
        guard articleToDisplay!.urlToImage != nil else {
            return
        }
        
        // Create url string
        let urlString = articleToDisplay!.urlToImage!
        
        // Check the cachemanager before downloading any image data
        if let imageData = CacheManager.retrievedData(urlString) {
            
            // There is image data, set the imageview and return
            articleImageView.image = UIImage(data: imageData)
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                
                self.articleImageView.alpha = 1
                
            }, completion: nil)
            
            return
        }
        
        // Create the url
        let url = URL(string: urlString)
        
        // Check that the url isn't nil
        guard url != nil else {
            print("Coudn't create the url object ")
            return
        }
        
        // Get a URLSession
        let session = URLSession.shared
        
        // Create the datatask
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            // Check that there no errors
            if error == nil && data != nil {
                
                // Save the date into cache
                CacheManager.saveData(urlString, data!)
                
                
                // Check if the url string that the data task went off download matches the article this cell is set to display
                if self.articleToDisplay!.urlToImage == urlString {
                    
                    DispatchQueue.main.async {
                        
                        // Dispaly the image data in the image view
                        self.articleImageView.image = UIImage(data: data!)
                        
                        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                            
                            self.articleImageView.alpha = 1
                            
                        }, completion: nil)
                        
                    }
                }
                
               
            } // End if
        } // End data task
        
        // Kick off the datatask
        dataTask.resume()
        
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
