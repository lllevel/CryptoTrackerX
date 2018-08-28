//
//  TableView.swift
//  ToTheMoon
//
//  Created by Шевель on 05.08.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit

var coinRank = Int()
var coinPrice = String()
var coinMarketCap = String()
var coinPeriod1H = Float()
var coinPeriod24H = Float()
var coinPeriod7D = Float()
var coinMaxSupply = String()
var coinVolume24H = String()
var coinCircSupply = String()

class CoinsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var priceFormat = "%.2f"
    var marketCapFormat = "%.0f"
    var ticker = "$"
    var coinRank1 = Int()
    let mainHeaderLabels = MainHeaderLabels()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CoinsTableCell
        
        cell.rank.text = String(rates[indexPath.row].rank)
        cell.symbol.text = rates[indexPath.row].symbol
        cell.picture.image = images[indexPath.row]
        
        if key == "BTC" {
            ticker = "\u{20BF}"
            priceFormat = "%.8f"
        } else {
            ticker = "$"
            priceFormat = "%.2f"
        }

        cell.price.text = String(format: priceFormat,rates[indexPath.row].quotes[key]!.price) + ticker
        cell.percentChange24h.text = String(format: "%.2f", rates[indexPath.row].quotes[key]!.percent_change_24h) + "%"
        
        if rates[indexPath.row].quotes[key]!.percent_change_24h < 0 {
            cell.percentChange24h.textColor = UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)
        } else {
            cell.percentChange24h.textColor = UIColor(displayP3Red: 0, green: 0.6, blue: 0, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idSelectedRow = indexPath.row
        symbolSelectedRow = rates[indexPath.row].symbol
        nameSelectedRow = rates[indexPath.row].name
        coinRank = rates[indexPath.row].rank
        coinPrice = String(format: priceFormat, rates[indexPath.row].quotes[key]!.price) + ticker
//        coinMarketCap = String(format: marketCapFormat, rates[indexPath.row].quotes[key]!.market_cap) + ticker
        coinMarketCap = String(mainHeaderLabels.separatedNumber(rates[indexPath.row].quotes[key]!.market_cap)) + "$"
        coinPeriod1H = rates[indexPath.row].quotes[key]!.percent_change_1h
        coinPeriod24H = rates[indexPath.row].quotes[key]!.percent_change_24h
        coinPeriod7D = rates[indexPath.row].quotes[key]!.percent_change_7d
        if rates[indexPath.row].max_supply != nil {
            coinMaxSupply = String(mainHeaderLabels.separatedNumber(rates[indexPath.row].max_supply!)) + " " + symbolSelectedRow
        } else {
            coinMaxSupply = "0 " + symbolSelectedRow
        }
        coinVolume24H = String(mainHeaderLabels.separatedNumber(rates[indexPath.row].quotes[key]!.volume_24h)) + "$"
        coinCircSupply = String(mainHeaderLabels.separatedNumber(rates[indexPath.row].circulating_supply)) + " " + symbolSelectedRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
