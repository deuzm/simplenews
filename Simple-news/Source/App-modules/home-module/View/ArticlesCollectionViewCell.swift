//
//  ArticlesCollectionViewCell.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import UIKit
import Kingfisher

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    var article: NewsModel? {
        didSet {
            let url = URL(string: article?.urlToImage ?? URL_TO_IMAGE)
            let processor = DownsamplingImageProcessor(size: thumbnailView.bounds.size)
            
            thumbnailView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"), options: [
                                      .processor(processor),
                                      .scaleFactor(UIScreen.main.scale),
                                      .transition(.fade(1)),
                                      .cacheOriginalImage
                                  ])
            
            titleLabel.text = article?.title
            
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.5
    
            subtitleLabel.text = article?.description
            if subtitleLabel.isTruncated {
                if subtitleLabel.text!.count > 1 {

                    let readmoreFont = subtitleLabel.font
                    let readmoreFontColor = UIColor.blue
                    DispatchQueue.main.async {
                        self.subtitleLabel.addTrailing(with: "... ", moreText: "Show more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
                    }
                }
            }
        }
    }
}
