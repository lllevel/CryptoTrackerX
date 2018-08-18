//
//  Main.swift
//  ToTheMoon
//
//  Created by Шевель on 28.07.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit

var url = String()
var url2 = String()
var key = String()
var rates = [CoinProperties]()
var images = [UIImage]()
var idSelectedRow = Int()
var symbolSelectedRow = String()
var globalData: GlobalData!

class Main: UIViewController {
    
    @IBOutlet weak var tableView: CoinsTable!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    
    var array10000 = [String]()
    var coinsIDs = [Int]()
    let refresher = UIRefreshControl()
    var spinner: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    var labelView = MainHeaderLabels()

    override func viewDidLoad() {
        super.viewDidLoad()

        key = "USD"
        setupNavigationBar()
        startSpinner()
        sendRequestCoinData()
        sendRequestGlobalData()
        
        array10000 = array()

        let stackViewHeader = UIStackView(arrangedSubviews: [labelView.totalMarketCapHeader, labelView.totalVolume24hHeader, labelView.bitcoinPercentageHeader])
        stackViewHeader.axis = .vertical
        stackViewHeader.spacing = 0
        stackViewHeader.frame.size = CGSize(width: max(labelView.totalMarketCapHeader.frame.size.width,
                                                       labelView.totalVolume24hHeader.frame.size.width,
                                                       labelView.bitcoinPercentageHeader.frame.size.width),
                                            height:    labelView.totalMarketCapHeader.frame.size.height
                                                     + labelView.totalVolume24hHeader.frame.size.height
                                                     + labelView.bitcoinPercentageHeader.frame.size.height)
        view.addSubview(stackViewHeader)
        stackViewHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: stackViewHeader, attribute: .left, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: stackViewHeader, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: -20))
        
        let stackViewData = UIStackView(arrangedSubviews: [labelView.totalMarketCapData, labelView.totalVolume24hData, labelView.bitcoinPercentageData])
        stackViewData.axis = .vertical
        stackViewData.spacing = 0
        stackViewData.frame.size = CGSize(width: max(labelView.totalMarketCapData.frame.size.width,
                                                     labelView.totalVolume24hData.frame.size.width,
                                                     labelView.bitcoinPercentageData.frame.size.width),
                                          height:    labelView.totalMarketCapData.frame.size.height
                                                   + labelView.totalVolume24hData.frame.size.height
                                                   + labelView.bitcoinPercentageData.frame.size.height)
        view.addSubview(stackViewData)
        stackViewData.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: stackViewData, attribute: .right, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: stackViewData, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: -20))
        
        tableView.delegate = tableView
        tableView.dataSource = tableView
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.bounces  = true
        
        refresher.addTarget(self, action: #selector(Main.didPullToRefresh), for: .valueChanged)
        refreshControl = refresher
        tableView.addSubview(refreshControl)
    }
    
    func sendRequestCoinData() {
        var ratesBuffer = [CoinProperties]()
        let jsonUrl = "https://api.coinmarketcap.com/v2/ticker/?convert=BTC&limit=100"
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: jsonUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
    
                do {
                    let websiteDescription = try
                        JSONDecoder().decode(CoinData.self, from: data)

                    for i in self.array10000 {
                        if websiteDescription.data[i] != nil {
                            self.coinsIDs.append(Int(i)!)
                            ratesBuffer.append(websiteDescription.data[i]!)
                        }
                    }
                    rates = self.sortTop(ratesBuffer: ratesBuffer)
                    self.getCoinsImages()

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }
    
    func sendRequestGlobalData() {
       let jsonUrl = "https://api.coinmarketcap.com/v2/global/?convert=BTC"
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: jsonUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                
                do {
                    globalData = try
                    JSONDecoder().decode(GlobalData.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.labelView.setupLabels()
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }

    func getCoinsImages() {
        var imagesBuffer = [UIImage]()
        
        for i in self.coinsIDs {
            let imageString = "https://s2.coinmarketcap.com/static/img/coins/64x64/\(i).png"
            guard let imageURL = URL(string: imageString) else { return }
            let imageData = NSData(contentsOf: imageURL)
            let image = UIImage(data: imageData! as Data)
            imagesBuffer.append(image!)
        }
        images = imagesBuffer
    }
    
    func array() -> [String] {
        var coins = [String]()
        
        for i in 1...10000 {
            coins.append(String(i))
        }
        return coins
    }
    
    func sortTop(ratesBuffer: [CoinProperties]) -> [CoinProperties] {
        var coins = [CoinProperties]()
        var ids = [Int]()
        
        for j in 0..<10000 {
            for i in ratesBuffer {
                if i.rank == j {
                    coins.append(i)
                    ids.append(Int(i.id))
                }
            }
        }
        coinsIDs = ids
        return coins
    }
    
    @IBAction func currencySegmentAction(_ sender: UISegmentedControl) {
        if spinner.isAnimating {
            return
        } else {
            switch  currencySegment.selectedSegmentIndex {
            case 0:
                key = "USD"
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.labelView.setupLabels()
                }
            case 1:
                key = "BTC"
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.labelView.setupLabels()
                }
            default:
                return
            }
        }
    }
    
    func startSpinner() {
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = UIColor(ciColor: .black)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        tableView.addSubview(spinner)
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        spinner.startAnimating()
    }
    
    @objc func didPullToRefresh() {
        sendRequestCoinData()
        sendRequestGlobalData()
        refreshControl.endRefreshing()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
    }
}

