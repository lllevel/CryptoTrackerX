//
//  CandleData.swift
//  CryptoTracker
//
//  Created by Алексей Шевель on 8/18/18.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

struct CandleData: Decodable {
    let Data: [CandleProperties]
}

struct CandleProperties: Decodable {
    let time: Int
    let close: Double
    let high: Double
    let low: Double
    let open: Double
    let volumefrom: Float
    let volumeto: Float
}
