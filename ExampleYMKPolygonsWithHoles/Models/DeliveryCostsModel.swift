//
//  DeliveryCostsModel.swift
//  ExampleYMKPolygonsWithHoles
//
//  Created by Станислав Шияновский on 9/1/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public struct DeliveryCostsModel: Codable, TablesProtocol {
    public var code: Int
    public var from: Int
    public var price: Int
    
    enum CodingKeys: String, CodingKey {
        case code = "Код"
        case from = "от"
        case price = "Цена"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        from = try container.decode(Int.self, forKey: .from)
        price = try container.decode(Int.self, forKey: .price)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(from, forKey: .from)
        try container.encode(price, forKey: .price)
    }
}
