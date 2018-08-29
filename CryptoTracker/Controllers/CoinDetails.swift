//
//  CoinDetailsViewController.swift
//  ToTheMoon
//
//  Created by Шевель on 29.07.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit
import Charts

var candles = [CandleProperties]()

class CoinDetails: UIViewController {
    
    @IBOutlet weak var chartView: CandleStickChartView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var period1h: UILabel!
    @IBOutlet weak var period24h: UILabel!
    @IBOutlet weak var period7D: UILabel!
    @IBOutlet weak var percent1h: UILabel!
    @IBOutlet weak var percent24h: UILabel!
    @IBOutlet weak var percent7D: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume24H: UILabel!
    @IBOutlet weak var maxSupply: UILabel!
    @IBOutlet weak var circSupply: UILabel!
    @IBOutlet weak var marketCapHeader: UILabel!
    @IBOutlet weak var maxSupplyHeader: UILabel!
    @IBOutlet weak var volume24HHeader: UILabel!
    @IBOutlet weak var circSupplyHeader: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var percent: UILabel!
    
    var spinner: UIActivityIndicatorView!
    let coinsTable = CoinsTable()
    let candleCount: Double = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        startSpinner()
        sendRequestCandleData()
        setChartView()
        setLabels()
    }
    
    func setChartView() {
        chartView.noDataText = ""
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = Int(candleCount * 0.8)
        chartView.pinchZoomEnabled = true
        chartView.legend.form = .none
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.1
        chartView.leftAxis.spaceBottom = 0.1
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    }
    
    func setLabels() {
        rank.text = "Rank \(coinRank)"
        price.text = "Price \(coinPrice)"
        
        period.text = "Period"
        percent.text = "Percent"
        period1h.text = "1H"
        period24h.text = "24H"
        period7D.text = "7D"
        
        marketCapHeader.text = "Market Cap"
        maxSupplyHeader.text = "Max Supply"
        volume24HHeader.text = "Volume 24H"
        circSupplyHeader.text = "Circ. Supply"
        
        percent1h.text = String(coinPeriod1H) + "%"
        percent24h.text = String(coinPeriod24H) + "%"
        percent7D.text = String(coinPeriod7D) + "%"
        
        marketCap.text = coinMarketCap
        maxSupply.text = coinMaxSupply
        volume24H.text = coinVolume24H
        circSupply.text = coinCircSupply
        
        if coinPeriod1H < 0 {
            percent1h.textColor = UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)
        } else {
            percent1h.textColor = UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)
        }
        
        if coinPeriod24H < 0 {
            percent24h.textColor = UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)
        } else {
            percent24h.textColor = UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)
        }
        
        if coinPeriod7D < 0 {
            percent7D.textColor = UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)
        } else {
            percent7D.textColor = UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)
        }
    }

    func setupNavigationBar() {
        let label = UILabel()
        label.text = nameSelectedRow
        
        let imageVIew = UIImageView(image: images[idSelectedRow])
        imageVIew.contentMode = .scaleAspectFit

        let stackView = UIStackView(arrangedSubviews: [label, imageVIew])
        stackView.axis = .horizontal
        stackView.frame.size = CGSize(width: label.frame.size.width + imageVIew.frame.size.width, height: max(label.frame.size.height, label.frame.size.height))
        stackView.spacing = 0

        navigationItem.titleView = stackView
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in

//            let mult = Double(range + 1)
            let high: Double = candles[i].high
            let low: Double = candles[i].low
            let open: Double = candles[i].open
            let close: Double = candles[i].close
//            let even = i % 2 == 0
            
//            let timeInterval = candles[i].time
//            let time = Date(timeIntervalSince1970: TimeInterval(candles[i].time))
//            let time2 = toString(date: time, format: "dd")
            
            return CandleChartDataEntry(x: Double(i), shadowH: high, shadowL: low, open: open, close: close)

            
        }
        let set1 = CandleChartDataSet(values: yVals1, label: "")
        
        set1.axisDependency = .left
        set1.shadowWidth = 1
        set1.decreasingColor = UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)
        set1.increasingFilled = true
        set1.neutralColor = UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)
        set1.shadowColor = UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)
        set1.shadowColorSameAsCandle = true
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
        
    }
    
    func sendRequestCandleData() {
        var candlesBuffer = [CandleProperties]()
        let jsonUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbolSelectedRow)&tsym=USD&limit=\(candleCount)"
        var jsonCount = 0
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: jsonUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                
                do {
                    let websiteDescription = try
                    JSONDecoder().decode(CandleData.self, from: data)
                    jsonCount = websiteDescription.Data.count
                    guard jsonCount >= 1 else {
                     self.chartView.noDataText = "No coin data"
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                        }
                        return
                    }
                    for i in 0..<jsonCount {
                        candlesBuffer.append(websiteDescription.Data[i])
                    }
                    candles = candlesBuffer
                    DispatchQueue.main.async {
                        self.setDataCount(jsonCount, range: 0)
                        self.spinner.stopAnimating()
                    }
                } catch let error {
                    print(error)
                    return
                }
            }.resume()
        }
    }
    
    func startSpinner() {
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = UIColor(ciColor: .black)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        chartView.addSubview(spinner)
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: chartView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: chartView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        spinner.startAnimating()
    }
    
    func toString(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateResult = formatter.string(from: date as Date)
        return dateResult
    }
}

