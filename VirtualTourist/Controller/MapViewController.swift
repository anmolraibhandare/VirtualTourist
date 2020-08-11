//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Anmol Raibhandare on 8/6/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePin: UIView!
    
    // MARK: Variables
    
    var currentPins:[Pin] = []
    var editButtonMode: Bool = false
    var gestureMode: Bool = false

    
    // MARK: Setup core data stack in MapViewController and Fetch Results
    
    func setUpCoreDataStack() -> DataController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.dataController
    }

    func setUpFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {

        let dataController = setUpCoreDataStack()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.sortDescriptors = []

        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.context, sectionNameKeyPath: nil, cacheName: nil)
    }

    // MARK: Preload the saved pins
    
    func loadSavedPins() -> [Pin]? {
        do {
            var pinArray:[Pin] = []
            let fetchedResultsController = setUpFetchedResultsController()
            try fetchedResultsController.performFetch()
            let pinNumber = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)

            for index in 0..<pinNumber {
                pinArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Pin)
            }
            return pinArray

        } catch {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        editButtonMode = false
        let savedPins = loadSavedPins()

        if savedPins != nil {
            currentPins = savedPins!

            for pin in currentPins {
                let coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                addAnnotations(fromCoordinate: coordinates)
            }
        }
    }
    
    // MARK: Annotations

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if !editButtonMode {
            performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
            mapView.deselectAnnotation(view.annotation, animated: false)
        } else {
            removeCoreData(of: view.annotation!)
            mapView.removeAnnotation(view.annotation!)
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureMode = true
        return true
    }

    // MARK: Action on map when long pressed
    
    @IBAction func longPressResponse(_ sender: Any) {

        if gestureMode {
            let gestureRecognizer = sender as! UILongPressGestureRecognizer
            let gestureTouchLocation = gestureRecognizer.location(in: mapView)
            addAnnotations(fromPoint: gestureTouchLocation)
            gestureMode = false
        }

    }

    func addAnnotations(fromPoint: CGPoint) {
        let coordinate = mapView.convert(fromPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addCoreData(of: annotation)
        mapView.addAnnotation(annotation)
    }

    func addAnnotations(fromCoordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = fromCoordinate
        mapView.addAnnotation(annotation)
    }

    func addCoreData(of: MKAnnotation) {
        do {
            let coordinate = of.coordinate
            let pin = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude, context: setUpCoreDataStack().context)
//        save context
            currentPins.append(pin)
        } catch {
            print("Failed")
        }
    }

    func removeCoreData(of: MKAnnotation) {
        do {
            let coordinate = of.coordinate

            for pin in currentPins {
                if pin.latitude == coordinate.latitude && pin.longitude == coordinate.longitude {
                    do {
                        setUpCoreDataStack().context.delete(pin)
                        try setUpCoreDataStack().saveContext()
                    } catch {
                        print("Failed")
                    }
                    break
                }
            }
        }
    }

    // MARK: Segue to PhotoViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PinPhotos" {
            let destination = segue.destination as! PhotoViewController
            let coordinate = sender as! CLLocationCoordinate2D
            destination.coordinate = coordinate

            for pin in currentPins {
                if pin.latitude == coordinate.latitude && pin.longitude == coordinate.longitude {
                    destination.corePin = pin
                    break
                }
            }
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deletePin.isHidden = !editing
        editButtonMode = editing
    }

}

