//
//  SearchViewController.swift
//  JukeBox
//
//  Created by Sameer on 19/07/17.
//  Copyright © 2017 Stone. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import LNPopupController
import Kingfisher


var songs = [Song]()

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
        //callAlamo(url: "http://api.soundcloud.com/tracks?client_id=340f063c670272fac27cfa67bffcafc4&q=Shawn+Mendes")

        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //change spaces with +
        let keywords = searchBar.text
        let finalkeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        songs.removeAll()
        searchURL = "http://api.soundcloud.com/tracks?client_id=340f063c670272fac27cfa67bffcafc4&q=\(finalkeywords!)"
        
        callAlamo(url: searchURL)
        
        self.searchBar.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func callAlamo(url: String){
        Alamofire.request(url,method: .get).validate().responseJSON(completionHandler: { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let value = json.count
                for i in 0..<value{
                    let tempJSON = json[i]
                    print(tempJSON["id"])
                    print(tempJSON["title"])
                    print(tempJSON["artwork_url"])
                    let tempSong = Song.build(json: tempJSON)
                    songs.append(tempSong!)
                }
                self.tableView.reloadData()
                //print(songs[0].title)
            case .failure(let error):
                print(error)
            }
        }
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(songs.count)
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let titleLabel = cell?.viewWithTag(1) as! UILabel
        print(songs.count)
        print(songs[indexPath.row].title)
        titleLabel.text = songs[indexPath.row].title
        
        let usernameLabel = cell?.viewWithTag(2) as! UILabel
        usernameLabel.text = songs[indexPath.row].username
        
        let artworkView = cell?.viewWithTag(3) as! UIImageView
        let url = URL(string: songs[indexPath.row].artwork)
        let image = UIImage(named: "artworkPlaceholder")
        artworkView.kf.setImage(with: url, placeholder: image)
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupContentController = storyboard?.instantiateViewController(withIdentifier: "MusicPlayerController") as! MusicPlayerController
//        popupContentController.popupItem.title = songs[indexPath.row].title
        //print(songs[indexPath.row].artwork)
        popupContentController.albumArtURL = songs[indexPath.row].artwork
        popupContentController.songTitle = songs[indexPath.row].title
        popupContentController.artistTitle = songs[indexPath.row].username
        popupContentController.id = songs[indexPath.row].id
        

        
        
        
//        popupContentController.popupItem.accessibilityHint = NSLocalizedString("Double Tap to Expand the Mini Player", comment: "")
//        tabBarController?.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString("Dismiss Now Playing Screen", comment: "")
//
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
//        tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
