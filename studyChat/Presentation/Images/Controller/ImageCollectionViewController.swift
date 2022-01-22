//
//  ImageCollectionViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 22.11.2021.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    
    var networkService: NetworkService?
    var imagesData: Response?
    var delegate: ImageCollectionDelegate?
    
    let cellIdentifier = String(describing: CustomImageCollectionViewCell.self)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(CustomImageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.color = .gray
        let transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        spinner.transform = transform
        spinner.backgroundColor = .clear
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func setConstraints() {
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConstraints()
        isLoading(true)
        if #available(iOS 15.0, *) {
            fetchRequest()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func isLoading(_ loadingInProgress: Bool) {
        if loadingInProgress {
            spinner.startAnimating()
            collectionView.isHidden = true
        } else {
            spinner.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    @available(iOS 15.0, *)
    func fetchRequest() {
        Task {
            do {
                guard let networkService = networkService else { return }
                let response = try await networkService.sendRequest()
                print("Swift Concurrency API call👇")
                updateCollectionView(with: response)
            }
        }
    }
    
    func updateCollectionView(with response: Response) {
        imagesData = response
        isLoading(false)
    }
    
}

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hits = imagesData?.hits else { return 20 }
        return hits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as?
                CustomImageCollectionViewCell else {
                    return UICollectionViewCell()
                }
        cell.imageView.image = UIImage(named: "defaultPlaceHolder")
        guard let hits = imagesData?.hits else { return cell }
        cell.networkService = networkService
        cell.configure(with: hits[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = (collectionView.frame.width - 20) / 3
        return CGSize(width: sideSize, height: sideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap on \(indexPath)")
        guard let imageUrl = imagesData?.hits[indexPath.row].webformatURL else { return }
        delegate?.setSelectedImage(imageUrl: imageUrl)
        self.dismiss(animated: true)
    }
}
