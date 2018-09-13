//
//  JSONSoundCloud.swift
//  JukeBox
//
//  Created by Sameer on 27/07/17.
//  Copyright © 2017 Stone. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Song{
    let id: Int!
    let title: String!
    let username: String!
    let artwork: String!
    
    init(id : Int, title:String, username: String, artwork: String){
        self.id = id
        self.title = title
        self.username = username
        self.artwork = artwork
    }
    
    class func build(json:JSON) -> Song? {
//        if json["artwork_url"].string != nil {
//            let artwork = json["artwork_url"].string
//        } else {
//            let artwork = "";
//        }
        if
        let artwork = (json["artwork_url"].string != nil) ? json["artwork_url"].string : "",
            let id = json["id"].int,
            let title = json["title"].string,
            let user = json["user"]["username"].string{
            return Song(id: id, title: title, username: user, artwork: artwork)
        } else {
            debugPrint("bad json \(json)")
            return nil
        }
        
    }
}
