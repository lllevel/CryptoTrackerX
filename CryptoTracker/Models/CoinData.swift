//
//  CoinMarketCap.swift
//  ToTheMoon
//
//  Created by Шевель on 12.07.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

struct CoinData: Decodable {
    
    let data: [String: CoinProperties]
}

struct CoinProperties: Decodable {
    
    let id: Int
    let rank: Int
    let symbol: String
    let quotes: [String: CoinPrice]
    let name: String
}

struct CoinPrice: Decodable {
    
    let price: Float
    let percent_change_24h: Float
}

