//
//  TableView.swift
//  ToTheMoon
//
//  Created by Шевель on 05.08.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit

class CoinsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CoinsTableCell
        var ticker = "$"
        var priceFormat = "%.2f"
        
        cell.rank.text = String(rates[indexPath.row].rank)
        cell.symbol.text = rates[indexPath.row].symbol
        cell.picture.image = images[indexPath.row]
        
        if key == "BTC" {
            ticker = "\u{20BF}"
            priceFormat = "%.8f"
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
