//
//  ArticlesPresenter.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import UIKit
import SafariServices

class NewsPresenter: ViewToPresenterNewsProtocol {
    
    
    var interactor: PresenterToInteractorNewsProtocol?
    
    var view: PresenterToViewNewsProtocol?
    
    var router: PresenterToRouterNewsProtocol?
    
    var viewRef: NewsViewController?//View reference of the main screen of this module i.e SearchController
    
    enum Section {
      case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NewsModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NewsModel>
    
    func fetchNews() {
        if interactor?.daysCounter ?? 0 < 7 {
            interactor?.fetchNews(pagination: true)
        }
        else
        {
            print("Reached pagination limit")
        }
    }
    
    func isPaginating() -> Bool {
        return interactor?.paginationEnabled ?? false
    }
    
    func updateDate() {
        interactor?.daysCounter = 0
        interactor?.newsList = []
        interactor?.fetchNews(pagination: false)
    }
    
    func startFetchingNews() {
        NewsRouter.createNewsModule(withPresenter: self)
        interactor?.fetchNews(pagination: true)
    }
    
    func fetchFromDatabase() -> [NewsModel] {
        return interactor?.fetchArticlesFromRealm() ?? []
    }
    
    func startFetchingNextPage() {
        guard interactor?.isPaginating == false else {
            return
        }
        fetchNews()
    }
    
}

extension NewsPresenter: InteractorToPresenterNewsProtocol{
    func newsFetchSuccess(newsList: Array<NewsModel>) {
        viewRef?.showArticles(newsModelArrayList: newsList)
    }
    
    func newsFetchFailed(with error: String) {
        viewRef?.showError(error: error)
    }
    
}
