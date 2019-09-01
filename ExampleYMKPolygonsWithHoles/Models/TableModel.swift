//
//  TableModel.swift
//  ExampleYMKPolygonsWithHoles
//
//  Created by Станислав Шияновский on 8/31/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public enum TableType {
    case territories
    case costs
    case none
}

public struct TableModel: Codable {
    
    public var tableName: String
    public var data: [TablesProtocol]
    public var type: TableType
    
    enum CodingKeys: String, CodingKey {
        case tableName = "TableName"
        case data = "Data"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tableName = try container.decode(String.self, forKey: .tableName)
        switch tableName {
        case "Территории":
            data = try container.decode([TerritoriesModel].self, forKey: .data)
            type = .territories
        case "СтоимостьДоставки":
            data = try container.decode([DeliveryCostsModel].self, forKey: .data)
            type = .costs
        default:
            data = []
            type = .none
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tableName, forKey: .tableName)
        
        switch tableName {
        case "Территории":
            try container.encode(data as? [TerritoriesModel], forKey: CodingKeys.data)
        case "СтоимостьДоставки":
            try container.encode(data as? [DeliveryCostsModel], forKey: CodingKeys.data)
        default: break
        }
    }
}

