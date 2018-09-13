//
//  MusicPlayerController.swift
//  JukeBox
//
//  Created by Sameer on 31/07/17.
//  Copyright © 2017 Stone. All rights reserved.
//

import Foundation
import UIKit
import LNPopupController
import AVFoundation
import Kingfisher
import MediaPlayer


var player: AVAudioPlayer!
var progressTimer: Timer!


class MusicPlayerController : UIViewController {
    

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var albmArtImageView: UIImageView!
    
    @IBOutlet var playPauseBtn: UIButton!
    
    
    var url = URL(string: "")
    var placeholderImage = UIImage(named: "artworkPlaceholder")
    
    var id: Int = 0 {
        didSet{
            print(id)
            let SoundCloudClientID = "340f063c670272fac27cfa67bffcafc4"
            
            let trackUrl = "http://api.soundcloud.com/tracks/\(id)/stream?client_id=\(SoundCloudClientID)"
            downloadFileFromURL(url: URL(string: trackUrl)!)
            
            //playPauseBtn.setTitle("Pause", for: .normal)
        }
    }
    
    var songTitle: String = "" {
        didSet {
            if isViewLoaded {
                print("Title")
                songNameLabel.text = songTitle
            }
            popupItem.title = songTitle
        }
    }
    var artistTitle: String = "" {
        didSet {
            if isViewLoaded {
                print("Artist")
                artistNameLabel.text = artistTitle
            }
            if ProcessInfo.processInfo.operatingSystemVersion.majorVersion <= 9 {
                popupItem.subtitle = artistTitle
            }
        }
    }
    var albumArtURL: String = "" {
        didSet {
            print("Album")
            if let popupUrl = URL(string: albumArtURL) {
                albumArtURL = albumArtURL.replacingOccurrences(of: "large.jpg", with: "t300x300.jpg")
                url = URL(string: albumArtURL)
                popupItem.image = loadPopupImage(url: popupUrl)
                popupItem.accessibilityImageLabel = NSLocalizedString("Album Art", comment: "")
            } else {
                popupItem.image = placeholderImage
            }
            if isViewLoaded {
                albmArtImageView.kf.setImage(with: url, placeholder: placeholderImage)
            } else {
                print("View not loaded")
            }
            
        }
    }
    
    func play(url: URL){
        do{
            if(player != nil && player.isPlaying) {
                player.stop()
            }
            player = try AVAudioPlayer(contentsOf : url)
            player.prepareToPlay()
            player.play()
            print("reached here")
            //progressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true);
            //progressTimer.fire();
            progressView.setProgress(Float(player.currentTime/player.duration), animated: false)
        }
        catch{
            print(error)
        }
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL,response,error in
            
            self.play(url: customURL!)
            
        })
        
        downloadTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("View loaded")
        songNameLabel.text = songTitle
        artistNameLabel.text = artistTitle
        
        //self.playPauseBtn.setTitle("pause", for: .normal)
        //albmArtImageView.image = placeholderImage
        
        albmArtImageView.kf.setImage(with: url, placeholder: placeholderImage)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true);
        //progressTimer.fire();
        
    }
    
    func updateAudioProgressView(){
        print("fired");
        print(player)
        //print(player.isPlaying);
        if player != nil && player.isPlaying{
            // Update progress
            print("lol")
            progressView.setProgress(Float(player.currentTime/player.duration), animated: true)
        }
        else{
            print("chut")
        }

    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.isPlaying{
            player.pause()
            playPauseBtn.setTitle("Play", for: .normal)
        }
        else{
            player.play()
            playPauseBtn.setTitle("Pause", for: .normal)
        }
    }
    func loadPopupImage(url: URL) -> UIImage{
        var popupImage = UIImage()
        ImageCache.default.retrieveImage(forKey: url.absoluteString, options: nil, completionHandler: { image, cacheType in
            if image != nil {
                popupImage = image!
                return
            } else {
                ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
                    image, error, url, data in
                    if image != nil {
                        ImageCache.default.store(image!, forKey: (url?.absoluteString)!)
                        popupImage = image!
                        return
                    } else {
                        popupImage = self.placeholderImage!
                    }
                }
            }
        })
        return popupImage
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
