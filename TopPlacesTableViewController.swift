//
//  TopPlacesTableViewController.swift
//  FotoFlickr
//
//  Created by Алексей Крестинин on 04.04.17.
//  Copyright © 2017 Alexey Krestinin. All rights reserved.
//

import UIKit

class TopPlacesTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var placesTableView: UITableView!

    let topPlacesApi = TopPlacesApi()
    var topPlacesArray = [TopPlacesInfo] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesTableView.dataSource = self
        
        loadData()
       
    
        
    
        // Do any additional setup after loading the view.
    }

    func loadData () {
        let loader = TopPlacesApi()
        loader.getTopPlaces(success: { places in
            DispatchQueue.main.sync {
            self.topPlacesArray = places
                print (self.topPlacesArray)
            }
        }, failure: { error in
            
            DispatchQueue.main.async {
                //                MBProgressHUD.hide(for: self.mapView,
                //                                   animated: true)
            }
            
            switch error {
            case TopPlacesApi.APIError.noPhotosFound:
                
                break
                
            default:
                break
            }
            print("\(error)")
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return topPlacesArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let object = topPlacesArray[indexPath.row]
        cell.textLabel?.text = object.description
        return cell
        
    }
    
}
