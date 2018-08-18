//
//  LabelView.swift
//  ToTheMoon
//
//  Created by Шевель on 05.08.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//
import UIKit

struct MainHeaderLabels {
    
    var bitcoinPercentageHeader = UILabel()
    var totalMarketCapHeader = UILabel()
    var totalVolume24hHeader = UILabel()
    var bitcoinPercentageData = UILabel()
    var totalMarketCapData = UILabel()
    var totalVolume24hData = UILabel()
    
    func setupLabels() {
        var ticker = ""
        
        if key != "USD" {
            ticker = "\u{20BF}"
        } else if key != "BTC" {
            ticker = "$"
        } else {
            return
        }

        totalMarketCapHeader.text = "Total Market Cap:"
        totalMarketCapHeader.textAlignment = .left
        totalMarketCapHeader.font = UIFont.systemFont(ofSize: 14)
        
        totalVolume24hHeader.text = "Total 24h Volume:"
        totalVolume24hHeader.textColor = .black
        totalVolume24hHeader.textAlignment = .left
        totalVolume24hHeader.font = UIFont.systemFont(ofSize: 14)
        
        bitcoinPercentageHeader.text = "Bitcoin Domination:"
        bitcoinPercentageHeader.textColor = .black
        bitcoinPercentageHeader.textAlignment = .left
        bitcoinPercentageHeader.font = UIFont.systemFont(ofSize: 14)
        
        guard let totalMarketCapFormat = globalData.data.quotes[key]?.total_market_cap else { return }
    
        totalMarketCapData.text = "\(separatedNumber(totalMarketCapFormat))" + ticker
        totalMarketCapData.textColor = .black
        totalMarketCapData.textAlignment = .right
        totalMarketCapData.font = UIFont.systemFont(ofSize: 14)
        
        guard let totalVolume24hFormat = globalData.data.quotes[key]?.total_volume_24h else { return }
        
        totalVolume24hData.text = "\(separatedNumber(totalVolume24hFormat))" + ticker
        totalVolume24hData.textColor = .black
        totalVolume24hData.textAlignment = .right
        totalVolume24hData.font = UIFont.systemFont(ofSize: 14)
        
        bitcoinPercentageData.text = "\(globalData.data.bitcoin_percentage_of_market_cap)%"
        bitcoinPercentageData.textColor = .black
        bitcoinPercentageData.textAlignment = .right
        bitcoinPercentageData.font = UIFont.systemFont(ofSize: 14)
    }
    
    func separatedNumber(_ number: Any) -> String {
        let formatter = NumberFormatter()
        
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        return formatter.string(from: itIsANumber)!
    }

}

