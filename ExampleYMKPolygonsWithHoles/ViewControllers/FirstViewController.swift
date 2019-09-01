//
//  FirstViewController.swift
//  ExampleYMKPolygonsWithHoles
//
//  Created by Станислав Шияновский on 8/31/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit
import YandexMapKit

public class FirstViewController: UIViewController {
    
    // Data
    private var mapView: YMKMapView!
    private let TARGET_LOCATION = YMKPoint(latitude: 56.235364, longitude: 43.466215)
    
    private var polygons: [[Polygon]]!
    
    public override func loadView() {
        super.loadView()
        
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = .white
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareMapView()
        preparePolygonsValues()
    }
    
    private func prepareMapView() {
        mapView = YMKMapView(frame: UIScreen.main.bounds)
        self.view.addSubview(mapView)
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 12, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
    
    private func preparePolygonsValues() {
        let url = Bundle.main.url(forResource: "Data", withExtension: "txt")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONDecoder().decode(DataModel.self, from: jsonData)
            guard let territories = json.data.filter({ $0.type == .territories }).first, let territoriesData = territories.data as? [TerritoriesModel] else { return }
            polygons = territoriesData.map { $0.polygons }
            createPolygonOverlays()
        }
        catch {
            print(error)
        }
    }
    
    private func createPolygonOverlays() {
        for item in polygons {
            
            // Подготовка точек внешнего периметра
            let basePolyPoints = item.first?.points.map({ YMKPoint(latitude: $0.latitude, longitude: $0.longitude) }) ?? []
            let outerRing = YMKLinearRing(points: basePolyPoints)
            
            // Подготовка точек внутренних периметров
            var otherPolyPoints = [[YMKPoint]]()
            if item.count > 1 {
                for (index, element) in item.enumerated() {
                    if index == 0 { continue }
                    let points = element.points.map({ YMKPoint(latitude: $0.latitude, longitude: $0.longitude) })
                    otherPolyPoints.append(points)
                }
            }
            let innerRings = otherPolyPoints.map { YMKLinearRing(points: $0) }
            let polygon = mapView.mapWindow.map.mapObjects.addPolygon(
                with: YMKPolygon(outerRing: outerRing, innerRings: innerRings))
            polygon.fillColor = UIColor.red.withAlphaComponent(0.3)
            polygon.strokeColor = UIColor.red.withAlphaComponent(0.3)
            polygon.strokeWidth = 2
            polygon.zIndex = 100
            polygon.isAccessibilityElement = true
        }
    }
}

