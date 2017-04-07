//
//  TopPlacesInfo.swift
//  FotoFlickr
//
//  Created by Алексей Крестинин on 05.04.17.
//  Copyright © 2017 Alexey Krestinin. All rights reserved.
//

import Foundation

//{ "place_id": "2eIY2QFTVr_DwWZNLg", "woeid": "24554868", "latitude": 52.883, "longitude": -1.974, "place_url": "\/United+Kingdom\/England", "place_type": "region", "place_type_id": 8, "timezone": "Europe\/London", "_content": "England, GB, United Kingdom", "woe_name": "England", "photo_count": "5874" },

struct TopPlacesInfo {
    
    let placeId: String
    let placeName:String?
    let description:String?
    
    init? (json:[String:Any]) {
        
        guard let placeId = json["place_id"] as? String
        else {
            return nil
        }
        self.placeId = placeId
        self.placeName = json["woe_name"] as? String
        self.description = json["_content"] as? String
        
        
    }
    
}
