//
//  ProductDetailViewController.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 30/09/2020.
//

import UIKit
import SafariServices

class PostDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var shopButton: UIButton!
    
    let buttonAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 17, weight: .light),
          .foregroundColor: UIColor.black,
          .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    var viewModel: PostDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonLayout()
        setupViewLayout()
    }
    
    private func setupButtonLayout() {
        let attributeString = NSMutableAttributedString(string: "SHOP",
                                                        attributes: buttonAttributes)
        shopButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func setupViewLayout() {
        self.nameLabel.text = viewModel.title
        self.merchantLabel.text = viewModel.merchant
        if let url = viewModel.urlImage {
            self.productImageView.loadImageUsingCacheWithUrlString(urlString: url)
        }
    }
    
    @IBAction func shop(_ sender: UIButton) {
        if let urlLink = viewModel.urlLink, let url = URL(string: urlLink) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - SFSafariViewControllerDelegate Implementation
extension PostDetailViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
