//
//  Article.swift
//  News
//
//  Created by Khoa Nguyen on 3/6/2022.
//

import Foundation

struct Article : Decodable {
    
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
    
    
    
}
