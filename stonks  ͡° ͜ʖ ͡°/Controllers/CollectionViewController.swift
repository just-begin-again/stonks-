//
//  CollectionViewController.swift
//  stonks͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 12/6/22.
//

import UIKit
import SnapKit

protocol PassDataDelegate {
    func passData(_ data: String)
}

class CollectionViewController: UICollectionViewController {
    var delegate: PassDataDelegate?
    var netContr = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.netContr.fetchJSON(urlStr: self.netContr.baseURL) { (result) in
            switch result {
            case .success(let data): self.netContr.parse(JSON: data)
            case .failure(let error): print(error)
            }
        }
        
        self.collectionView.register(CurrencyCollectionCell.self, forCellWithReuseIdentifier: C.collectionCellId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.collectionView.reloadData()
        }
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(Float(netContr.currencies.count).squareRoot())
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Float(netContr.currencies.count).squareRoot())
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.collectionCellId, for: indexPath) as! CurrencyCollectionCell
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.collectionCellId, for: indexPath) as! CurrencyCollectionCell
        
        cell.toggleSelected()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.collectionCellId, for: indexPath) as! CurrencyCollectionCell
        cell.toggleSelected()
    }
}
