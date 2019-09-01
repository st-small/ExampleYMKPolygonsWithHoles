//
//  DataModel.swift
//  ExampleYMKPolygonsWithHoles
//
//  Created by Станислав Шияновский on 8/31/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public struct DataModel: Codable {
    
    public var success: Bool
    public var data: [TableModel]
    public var message: String
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case data = "Data"
        case message = "Message"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        data = try container.decode([TableModel].self, forKey: .data)
        message = try container.decode(String.self, forKey: .message)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(data, forKey: .data)
        try container.encode(message, forKey: .message)
    }
}
