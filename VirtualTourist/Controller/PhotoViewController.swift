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

class PhotoViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollection: UIButton!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var coordinate: CLLocationCoordinate2D!
    let spacing:CGFloat = 5
    let totalCells:Int = 25
    
    var dataController: DataController!
    var photos: [Photo] = []
    var pin: Pin!
    var toDelete: [Int] = []{
        
        didSet {
            if toDelete.count > 0 {
                newCollection.setTitle("Remove Pictures", for: .normal)
            } else {
                newCollection.setTitle("New Collection", for: .normal)
            }
        }
    }
    
    func setUpCoreDataStack() -> DataController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.dataController
    }

    func setUpFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {

        let dataController = setUpCoreDataStack()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin = %@", argumentArray: [pin!])

        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.context, sectionNameKeyPath: nil, cacheName: nil)
    }

    func loadSavedPhotos() -> [Photo]? {
        do {
            var photoArray:[Photo] = []
            let fetchedResultsController = setUpFetchedResultsController()
            try fetchedResultsController.performFetch()
            let photoNumber = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)

            for index in 0..<photoNumber {
                photoArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Photo)
            }
            return photoArray.sorted(by: {$0.index < $1.index})
        } catch {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gap = 3.0
        let dimension = (Double(self.view.frame.size.width) - (2 * gap)) / 3.0
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        
        collectionView.delegate = self
//        collectionView.dataSource = self
        
        newCollection.isHidden = false
        
        collectionView.allowsMultipleSelection = true
        addAnnotation()
        
        let savedPhoto = loadSavedPhotos()
        if savedPhoto != nil && savedPhoto?.count != 0 {
            photos = loadSavedPhotos()!
            displaySavedResult()
        } else {
            displayNewResult()
        }
    }
    
    func displaySavedResult() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func displayNewResult(){
        
    }
    
    func addAnnotation() {
        
    }


}
