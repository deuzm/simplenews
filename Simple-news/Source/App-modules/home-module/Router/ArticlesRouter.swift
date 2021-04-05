//
//  ArticlesRouter.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import UIKit
import SafariServices

class NewsRouter: PresenterToRouterNewsProtocol {
    
    class func createNewsModule(withPresenter presenter: NewsPresenter) {
        presenter.router = NewsRouter()
        presenter.interactor = NewsInteractor()
        presenter.interactor?.presenter = presenter
    }
}

// MARK: - SFSafariViewControllerDelegate Implementation
extension NewsViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
