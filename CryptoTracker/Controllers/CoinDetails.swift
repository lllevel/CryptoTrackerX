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

//enum Option {
//
//    case toggleShadowColorSameAsCandle
//    case toggleShowCandleBar
//    var label: String {
//        switch self {
//        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
//        case .toggleShowCandleBar: return "Toggle show candle bar"
//        }
//    }
//}

class CoinDetails: UIViewController {
    
    @IBOutlet weak var chartView: CandleStickChartView!
    var spinner: UIActivityIndicatorView!
//    private var optionsTableView: UITableView? = nil
//    var options: [Option]!
//    var shouldHideData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        startSpinner()
        sendRequestCandleData()
        
//        nameView.text = nameSelectedRow
//        setDataCount(25, range: 15)

//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//
//        setChart(dataPoints: months, values: unitsSold)
//        self.options = [.toggleShadowColorSameAsCandle,
//                        .toggleShowCandleBar]

//
        chartView.noDataText = ""
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 26
        chartView.pinchZoomEnabled = true
        
        chartView.legend.form = .none
        
//        chartView.legend.horizontalAlignment = .right
//        chartView.legend.verticalAlignment = .top
//        chartView.legend.orientation = .horizontal
//        chartView.legend.drawInside = true
//        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
//
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.1
        chartView.leftAxis.spaceBottom = 0.1
//        chartView.leftAxis.axisMinimum = 5000
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        
        
        
    }
    
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            self.initialize()
//        }
//
//        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//            self.initialize()
//        }
//
//        private func initialize() {
//            self.edgesForExtendedLayout = []
//        }

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
//        set1.setColor(UIColor(white: 80/255, alpha: 1))
//        set1.drawVerticalHighlightIndicatorEnabled = false
//        set1.drawValuesEnabled = false
//        set1.drawIconsEnabled = false
//        set1.shadowColor = .darkGray
        set1.shadowWidth = 1
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = .green
        set1.increasingFilled = true
        set1.neutralColor = .blue
        set1.shadowColor = .red
        
        set1.shadowColorSameAsCandle = true
        
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
        
    }
//    func optionTapped(_ option: Option) {
//        switch option {
//        case .toggleShadowColorSameAsCandle:
//            for set in chartView.data!.dataSets as! [CandleChartDataSet] {
//                set.shadowColorSameAsCandle = !set.shadowColorSameAsCandle
//            }
//            chartView.notifyDataSetChanged()
//        case .toggleShowCandleBar:
//            for set in chartView.data!.dataSets as! [CandleChartDataSet] {
//                set.showCandleBar = !set.showCandleBar
//            }
//            chartView.notifyDataSetChanged()
//        }
//    }
    

    
    func sendRequestCandleData() {
        var candlesBuffer = [CandleProperties]()
        let jsonUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbolSelectedRow)&tsym=USD&limit=25"
        var jsonCount = 0
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: jsonUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                
                do {
                    let websiteDescription = try
                    JSONDecoder().decode(CandleData.self, from: data)
                    jsonCount = websiteDescription.Data.count - 1
                    guard jsonCount >= 0 else {
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
    
//        func updateChartData() {
//            if self.shouldHideData {
//                chartView.data = nil
//                return
//            }
//    
//            self.setDataCount(5, range: 10)
//        }

}

//extension CandleChartDataEntry {
//
//    override public init(x: Double, y: Double) {
//        <#code#>
//    }
//}
