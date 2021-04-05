//
//  ArticlesProtocols.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import Foundation
import UIKit


protocol ViewToPresenterNewsProtocol:class{
    
    //Presenter protocol
    var view: PresenterToViewNewsProtocol? {get set}
    var interactor: PresenterToInteractorNewsProtocol? {get set}
    var router: PresenterToRouterNewsProtocol? {get set}
    func startFetchingNews()
    func startFetchingNextPage()
    
}

protocol PresenterToViewNewsProtocol:class {
    
    func showArticles(newsModelArrayList:Array<NewsModel>)
    func showError(error:String)
    
}

protocol PresenterToInteractorNewsProtocol {
    
    //Interactor protocol
    var presenter: InteractorToPresenterNewsProtocol? { get set }
    var paginationEnabled: Bool { get set }
    var isPaginating: Bool { get set }
    var daysCounter: Int { get set }
    var newsList: Array<NewsModel> { get set }
    func fetchNews(pagination: Bool)
    func fetchArticlesFromRealm() -> [NewsModel]
}

protocol PresenterToRouterNewsProtocol:class {
    
    //router protocol
    static func createNewsModule(withPresenter presenter: NewsPresenter)

}

protocol InteractorToPresenterNewsProtocol {
    
    func newsFetchSuccess(newsList:Array<NewsModel>)
    func newsFetchFailed(with error: String)
    
}
