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
    let circulating_supply: Float
    let max_supply: Float?
}

struct CoinPrice: Decodable {
    
    let price: Float
    let percent_change_24h: Float
    let percent_change_1h: Float
    let percent_change_7d: Float
    let market_cap: Float
    let volume_24h: Float
}

