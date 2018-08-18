//
//  CoinDetailsViewController.swift
//  ToTheMoon
//
//  Created by Шевель on 29.07.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit
import Charts

var candles = [CoinProperties]()

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

class CoinDetails: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: CandleStickChartView!
//    private var optionsTableView: UITableView? = nil
//    var options: [Option]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        sendRequestCandleData()
        setDataCount(5, range: 5)

//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//
//        setChart(dataPoints: months, values: unitsSold)
//        self.options = [.toggleShadowColorSameAsCandle,
//                        .toggleShowCandleBar]
//        
        chartView.delegate = self
//
        chartView.chartDescription?.enabled = false
//
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = true
//
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
//
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
//
        chartView.rightAxis.enabled = false
//
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        
    }

    func setupNavigationBar() {
        let label = UILabel()
        label.text = symbolSelectedRow
        
        let imageVIew = UIImageView(image: images[idSelectedRow])
        imageVIew.contentMode = .scaleAspectFit

        let stackView = UIStackView(arrangedSubviews: [label, imageVIew])
        stackView.axis = .horizontal
        stackView.frame.size = CGSize(width: label.frame.size.width + imageVIew.frame.size.width, height: max(label.frame.size.height, label.frame.size.height))
        stackView.spacing = 0

        navigationItem.titleView = stackView
    }
    
//    func setChart(dataPoints: [String], values: [Double]) {
//        barChartView.noDataText = "You need to provide data for the chart."
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
////            (value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
////        (yVals: dataEntries, label: "Units Sold")
//        let chartData = BarChartData(dataSet: chartDataSet)
////        (xVals: months, dataSet: chartDataSet)
//        barChartView.data = chartData
//    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let val: Double = 400
            let high: Double = 100
            let low: Double = 60
            let open: Double = 70
            let close: Double = 90
            let even = i % 2 == 0
         
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close)
        }
        
        let set1 = CandleChartDataSet(values: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
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
        let jsonUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbolSelectedRow)&tsym=USD&limit=100"
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: jsonUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                
                do {
                    let websiteDescription = try
                        
                    JSONDecoder().decode(CandleData.self, from: data)
                    for i in 0..<100 {
                        candlesBuffer.append(websiteDescription.Data[i])
                    }
                    DispatchQueue.main.async {
//                        self.setDataCount(1, range: 10)
                    }
                } catch let error {
                    print(error)
                }
                }.resume()
        }
    }
}
