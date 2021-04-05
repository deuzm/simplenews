//
//  ArticlesViewController.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import UIKit
import SafariServices

class NewsViewController: UICollectionViewController {
    //MARK: - Properties
    
    var presenter: NewsPresenter = NewsPresenter()
    
    enum Section {
      case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NewsModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NewsModel>
    
    private lazy var dataSource = makeDataSource()
    private var newsList: [NewsModel] = []
    private var allArticles: [NewsModel] = []
    private var searchController = UISearchController(searchResultsController: nil)
    private var isSearching = false

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.viewRef = self
        presenter.startFetchingNews()
        configureSearchController()
        configureLayout()
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }

    // MARK: - Functions
    
    // Pull to refresh fuctionality
    @objc private func didPullToRefresh() {
        Dispatch.DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
            self.presenter.updateDate()
        }
    }
    
    // apply snapshot for diffable data source
    func applySnapshot(animatingDifferences: Bool = true) {

        var snapshot = Snapshot()

        snapshot.appendSections([.main])

        snapshot.appendItems(newsList)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: - Data source
    func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, article) ->
            UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NewsCollectionViewCell",
            for: indexPath) as? NewsCollectionViewCell
            cell?.article = article
            return cell
        })
        return dataSource
    }
    
}

// MARK: - Presenter notifiers

extension NewsViewController: PresenterToViewNewsProtocol {
    func showError(error: String) {
        self.newsList = presenter.fetchFromDatabase()
        
        self.collectionView.refreshControl?.endRefreshing()
//        self.connectionFailed.isHidden = false
        self.allArticles = self.newsList
        self.applySnapshot()
//        connectionFailed.isHidden = false
    }
    
    func showArticles(newsModelArrayList: Array<NewsModel>) {
//        connectionFailed.isHidden = true
        
        self.collectionView.refreshControl?.endRefreshing()
        self.newsList = newsModelArrayList
        self.allArticles = newsList
        self.applySnapshot(animatingDifferences: false)
    }
    
}
// MARK: - UICollectionViewDelegate
extension NewsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    guard let news = dataSource.itemIdentifier(for: indexPath) else {
      return
    }

    guard let link = news.url else {
      print("Invalid link")
      return
    }
        
    let safariViewController = SFSafariViewController(url: URL(string: link)!)
    present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension NewsViewController: UISearchResultsUpdating {
    
  func updateSearchResults(for searchController: UISearchController) {
    isSearching = true
    newsList = filteredNews(for: searchController.searchBar.text)
    applySnapshot()
  }
  
  func filteredNews(for queryOrNil: String?) -> [NewsModel] {
    
        let news = allArticles
    
        guard let query = queryOrNil, !query.isEmpty else {
            isSearching = false
            return news
        }
    
        return news.filter {
            return $0.title!.lowercased().contains(query.lowercased())
        }
    
  }
  
    func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search News"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
}

// MARK: - Layout Handling
extension NewsViewController {
  private func configureLayout() {
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.absolute(400)
      )
      let itemCount = 1
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      return section
    })
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { context in
      self.collectionView.collectionViewLayout.invalidateLayout()
    }, completion: nil)
  }
}


//MARK: - Scroll view did scroll delegate functions(pagination)
extension NewsViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - 400 - scrollView.frame.size.height) {
            if(isSearching == false) {
                presenter.startFetchingNextPage()
            }
        }
    }
}

