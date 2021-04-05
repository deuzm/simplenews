//
//  ArticlesModel.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import Foundation
import UIKit


struct Source: Decodable {
    
    public let id = UUID()
    public let name: String?
    public init(name: String)
    {
        self.name = name
    }
}

struct NewsModel: Decodable, Hashable {
    
    public let source: Source
    public let title: String?
    public let description: String
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String
    // 1
    func hash(into hasher: inout Hasher) {
      // 2
        hasher.combine(source.id)
    }

    // 3
    static func == (lhs: NewsModel, rhs: NewsModel) -> Bool {
        lhs.source.id == rhs.source.id
    }
   
    public init(sourceName name : String, title: String, description: String, url: String, urlToImage: String, publishedAt: String) {
        print("2200202")
        self.source = Source(name: name)
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
}

struct AllArticles: Decodable {
    var articles: [NewsModel] = []
}
