//
//  ArticlesInteractor.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import Foundation
import Alamofire
import RealmSwift

class NewsInteractor: PresenterToInteractorNewsProtocol {
    
    
    var presenter: InteractorToPresenterNewsProtocol?
    
    var daysCounter: Int = -1
    var newsList: [NewsModel] = []
    var isPaginating: Bool = false
    var paginationEnabled: Bool = false
    
    func fetchNews(pagination: Bool = false) {
        if pagination == true {
            paginationEnabled = true
            daysCounter += 1
        }
        else {
            paginationEnabled = false
        }
        isPaginating = true
        let dayToFetch = Calendar.current.date(byAdding: .day, value: -daysCounter, to: Date())!.toString()
        print(dayToFetch)
        let REQUEST_PARAMS = [
            "q": "null",
            "from": dayToFetch,
            "to": dayToFetch,
            "language": "ru"
        ]
        Dispatch.DispatchQueue.global().async {
            AF.request(API_NEWS_LIST,
                       parameters: REQUEST_PARAMS,
                       headers: REQUEST_HEADERS)
                .validate()
                .responseDecodable(of: AllArticles.self) { (response) in
                    switch response.result {
                    case .success(let data):
                        if pagination != false {
                            
                            //resets database values on pull in case of success
                            self.realmDeleteAllClassObjects()
                            
                        }
                        self.newsList.append(contentsOf: data.articles)
                        self.isPaginating = false
                        
                        //saves articles of one day
                        self.saveArticlesToRealm(articles: data.articles)
                        print("neow")
                        print(data.articles[0].publishedAt)
                        print("meow")
                        self.presenter!.newsFetchSuccess(newsList: self.newsList)
                    case .failure(let error):
                        self.isPaginating = false
                        self.presenter!.newsFetchFailed(with: error.failureReason ?? "Undefined error")
                        print(error)
                }
            }
        }
    }
    
    private func saveArticlesToRealm(articles: [NewsModel]) {
        
        let realm = try! Realm()
        var realmNews: [RealmNewsObject] = []
        
        for item in articles {
            let realmObject = RealmNewsObject()
            realmObject.sourceName = item.source.name!
            realmObject.title = item.title!
            realmObject.newsDescription =  item.description
            realmObject.url = item.url!
            realmObject.urlToImage = item.urlToImage!
            realmObject.publishedAt = item.publishedAt
            realmNews.append(realmObject)
        }
        
        try! realm.write {
            for a in realmNews {
                realm.add(a)
            }
        }
    }
        
    func fetchArticlesFromRealm() -> [NewsModel] {
        
        let realm = try! Realm()
        let news = realm.objects(RealmNewsObject.self)
        var diffableNews: [NewsModel] = []
        
        for article in news {
            let diffableArticle: NewsModel = NewsModel(sourceName: article.sourceName, title: article.title ?? "", description: article.newsDescription, url: article.url ?? "", urlToImage: article.urlToImage ?? URL_TO_IMAGE, publishedAt: article.publishedAt)
            diffableNews.append(diffableArticle)
        }
        return diffableNews
    }
    
    func realmDeleteAllClassObjects() {
        do {
            let realm = try Realm()

            let objects = realm.objects(RealmNewsObject.self)

            try! realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
}
