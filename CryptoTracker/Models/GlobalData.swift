//
//  GlobalData.swift
//  ToTheMoon
//
//  Created by Шевель on 03.08.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

struct GlobalData: Decodable {
    
    let data: GlobalProperties
}

struct GlobalProperties: Decodable {
    
    let bitcoin_percentage_of_market_cap: Float
    let quotes: [String: GlobalTotal]
}

struct GlobalTotal: Decodable {
    
    let total_market_cap: Int
    let total_volume_24h: Int
}


