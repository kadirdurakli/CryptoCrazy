//
//  ViewController.swift
//  CryptoCrazy
//
//  Created by Kadir Duraklı on 11.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var crypoList = [Crypto]()
    let cryptoViewModel = CryptoViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpBinding()
        cryptoViewModel.requestData()
    }
    
    private func setUpBinding() {
        
        cryptoViewModel
            .loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        cryptoViewModel
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        cryptoViewModel
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.crypoList = cryptos
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crypoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = crypoList[indexPath.row].currency
        content.secondaryText = crypoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }

}

