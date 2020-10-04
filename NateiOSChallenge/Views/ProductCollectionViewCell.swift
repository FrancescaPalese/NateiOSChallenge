//
//  ProductCollectionViewCell.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 28/09/2020.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var productImageView: UIImageView!
    @IBOutlet public var activityIndicatorView: UIActivityIndicatorView!
    var downloadTask: URLSessionDownloadTask?
    
    var post: Post? {
        didSet {
            self.nameLabel.text = post?.product.title
            if post?.product.images?.count != 0 {
                if let urlString = post?.product.images?[0] {
                    downloadTask = productImageView.loadImage(urlString: urlString) { isLoaded in
                        
                        if isLoaded {
                            print("to do stuff")
                            self.activityIndicatorView.stopAnimating()
                            self.activityIndicatorView.removeFromSuperview()
                        }
                        else {
                            self.activityIndicatorView.stopAnimating()
                            self.activityIndicatorView.removeFromSuperview()
                            self.productImageView.backgroundColor = .lightGray
                        }
                    }
                    
                }
            } else {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                productImageView.backgroundColor = .lightGray
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.awakeFromNib()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicatorView.startAnimating()
//        self.layer.borderWidth = 1.0
//        self.layer.cornerRadius = 8.0
//        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        self.productImageView.image = nil
        downloadTask?.cancel()
        downloadTask = nil
    }
    

}
