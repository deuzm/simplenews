//
//  ArticlesRealmModel.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import Foundation
import RealmSwift

class RealmNewsObject: Object {

    @objc public var sourceName: String = ""
    @objc public var title: String? = ""
    @objc public var newsDescription: String = ""
    @objc public var url: String? = ""
    @objc public var urlToImage: String? = ""
    @objc public var publishedAt: String = ""
   
}
