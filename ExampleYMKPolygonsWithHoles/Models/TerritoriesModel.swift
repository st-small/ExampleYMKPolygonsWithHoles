//
//  TerritoriesModel.swift
//  ExampleYMKPolygonsWithHoles
//
//  Created by Станислав Шияновский on 9/1/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol TablesProtocol { }
public struct TerritoriesModel: Codable, TablesProtocol {
    public var code: Int
    public var title: String
    public var polygonString: String
    public var description: String
    public var minLatitude: Double
    public var minLongitude: Double
    public var maxLatitude: Double
    public var maxLongitude: Double
    
    public var polygons: [Polygon] {
        return createPolygons()
    }
    
    enum CodingKeys: String, CodingKey {
        case code = "Код"
        case title = "Наименование"
        case polygon = "Полигон"
        case description = "Информация"
        case minLatitude = "МинШирота"
        case minLongitude = "МинДолгота"
        case maxLatitude = "МаксШирота"
        case maxLongitude = "МаксДолгота"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        title = try container.decode(String.self, forKey: .title)
        polygonString = try container.decode(String.self, forKey: .polygon)
        description = try container.decode(String.self, forKey: .description)
        minLatitude = try container.decode(Double.self, forKey: .minLatitude)
        minLongitude = try container.decode(Double.self, forKey: .minLongitude)
        maxLatitude = try container.decode(Double.self, forKey: .maxLatitude)
        maxLongitude = try container.decode(Double.self, forKey: .maxLongitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(title, forKey: .title)
        try container.encode(polygonString, forKey: .polygon)
        try container.encode(minLatitude, forKey: .minLatitude)
        try container.encode(minLongitude, forKey: .minLongitude)
        try container.encode(maxLatitude, forKey: .maxLatitude)
        try container.encode(maxLongitude, forKey: .maxLongitude)
    }
    
    private func createPolygons() -> [Polygon] {
        guard !polygonString.isEmpty else { return [] }
        var polygons = [Polygon]()
        var polygonPoints = [PolygonPoint]()
        let arrays = polygonString.components(separatedBy: "]],")
        
        let set = CharacterSet(charactersIn: "0123456789.")
        for array in arrays {
            let stripped = array.components(separatedBy: set.inverted).filter({ !$0.isEmpty })
            polygonPoints.removeAll()
            var i = 0
            while i < stripped.count {
                let latitude = NSDecimalNumber(string: stripped[i]).doubleValue
                let longitude = NSDecimalNumber(string: stripped[i+1]).doubleValue
                let coordinate = PolygonPoint(latitude: latitude, longitude: longitude)
                polygonPoints.append(coordinate)
                i += 2
            }
            let polygon = Polygon(points: polygonPoints)
            polygons.append(polygon)
        }
        
        return polygons
    }
}

public struct Polygon {
    public var points: [PolygonPoint]
}

public struct PolygonPoint {
    public var latitude: Double
    public var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
