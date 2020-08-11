//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/10/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var newCollection: UIButton!
    
    
    var coordinate: CLLocationCoordinate2D!
    let spacing:CGFloat = 5
    let totalCells:Int = 25
    
    var dataController: DataController!
    var photos: [Photo] = []
    var pin: Pin!
    var toDelete: [Int] = []{
        
        didSet {
//            if toDelete.
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    


}
