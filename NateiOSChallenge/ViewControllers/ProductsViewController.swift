//
//  ViewController.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 28/09/2020.
//

import UIKit

enum Section {
    case main
}


class ProductsViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
    
    var viewModel: PostsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        snapshot.appendSections([.main])
        productsCollectionView.delegate = self
        
        viewModel = PostsViewModel()
        
        self.makeDataSource()
        self.applySnapshot()
//        viewModel.createProduct() { result in
//            switch result {
//            case .success(_):
//                print("CREATED")
//            case .failure(_):
////                TODO: handle the error
//                print("fetch products failed")
//            }
//        }
        viewModel.fetchPosts() { result in
            switch result {
            case .success(let model):
                self.viewModel = model
                
                DispatchQueue.main.async {
                    self.applySnapshot()
                }
            case .failure(_):
 //                TODO: handle the error
                print("fetch products failed")
            }
        }
        
    }
    
    private func makeDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<ProductCollectionViewCell, Post>(cellNib: UINib(nibName: "ProductCollectionViewCell", bundle: nil)) { (cell, indexPath, post) in
            
            cell.post = post
            
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: self.productsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Post) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }
    }
    
    private func applySnapshot() {
        snapshot.appendItems(self.viewModel.posts)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateSnapshot() {
        var updatedSnapshot = self.dataSource.snapshot()
        updatedSnapshot.appendItems(self.viewModel.currentFetchedPosts)
        self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
    }
    
    @IBAction func addProduct(_ sender: Any) {
        
    }
    
}

extension ProductsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
            nextViewController.viewModel = ProductDetailViewModel(with: post)
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) {
            viewModel.fetchPosts() { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.updateSnapshot()
                    }
                case .failure(_):
                    //                    TODO: handle the error
                    print("fetch products failed")
                    
                }
            }
        }
    }
    
    
    
    ////
    ////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    ////        return viewModel.totalProducts
    ////    }
    ////
    ////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    ////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
    ////
    ////        cell.configure(with: viewModel.product(at: indexPath.row))
    ////        return cell
    ////
    ////    }
    ////
    //
    
}

extension ProductsViewController: UIScrollViewDelegate {
    //     func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let offsetY = scrollView.contentOffset.y
    //                let contentHeight = scrollView.contentSize.height
    //
    //                if (offsetY > contentHeight - scrollView.frame.height * 4) {
    //                    viewModel.fetchProducts() { result in
    //                        switch result {
    //                        case .success(let products):
    //                            self.applySnapshot()
    //
    //                        case .failure(let error):
    //                            print("failed")
    //
    //                        }
    //                    }
    //                }
    //    }
}


extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = self.view.window?.frame {
            return CGSize(width: size.width - 40, height: size.height/3 * 2 )
        }
        //        TODO: check this func
        return CGSize(width: 0, height: 0)
    }
    
    
}
