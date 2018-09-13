//
//  SecondViewController.swift
//  JukeBox
//
//  Created by Sameer on 19/07/17.
//  Copyright © 2017 Stone. All rights reserved.
//

import UIKit
import MediaPlayer
import StoreKit
//import AppleMusicSongStruct
//import SQLite

var itemArray = [MPMediaItem]()
var mediaCollection: MPMediaItemCollection?


var tableArray: [String] = ["Songs", "Artist", "Albums", "Playlist"]

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var songArray = [appleSongs]()
    var albumArray = [appleAlbums]()
    var playlistArray = [applePlaylist]()
    var artistArray = [appleArtists]()

    
    @IBOutlet weak var LibraryTableView: UITableView!
    var storedOffsets = [Int: CGFloat]()
    var myMusicPlayer = MPMusicPlayerController()
    var applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    override func viewDidLoad() {
        
        
        let query = MPMediaQuery.songs()
        mediaCollection = MPMediaItemCollection(items: query.items!)
        itemArray = mediaCollection!.items
        print(itemArray[0].playbackStoreID)
        let count = itemArray.count
        print(itemArray.count)
        for i in 0..<count{
            let song = MPMediaToSong(media: itemArray[i])
            songArray.append(song)
        }
        print(songArray[0].playbackID)
        print(songArray[0].duration)
        print(songArray[0].title)
        print(songArray[0].artist)
        print(songArray[0].album)
        let UIimage = itemArray[0].artwork
        print(type(of: UIimage))
        
        let queryArtists = MPMediaQuery.artists()
        let artists = queryArtists.collections
        print((artists?.count)!)
        let artistCount = (artists?.count)!
        for i in 0..<artistCount{
            let num = (artists?[i].count)!
            let collection = MPMediaItemCollection(items: (artists?[i].items)!)
            let tempArtist = collection.items
            let artistID = tempArtist[0].artistPersistentID
            var tempArtistArray = [appleSongs]()
            print(artistID)
            print(type(of: artistID))
            for j in 0..<num{
                let song = MPMediaToSong(media: tempArtist[j])
                tempArtistArray.append(song)
                print(song.title)
            }
            let artist = appleArtists(count: num, artistId: String(artistID), artistName: tempArtistArray[0].artist, songs: tempArtistArray)
            print("hello")
            artistArray.append(artist)
        }
        
        
        let queryPlaylist = MPMediaQuery.playlists()
        let playlists = queryPlaylist.collections
        print((playlists?.count)!)
        let playlistCount = (playlists?.count)!
        for i in 0..<playlistCount{
            let name = (playlists?[i].value(forProperty: MPMediaPlaylistPropertyName) as! String)
            print(name)
            let num = (playlists?[i].count)!
            let collection = MPMediaItemCollection(items: (playlists?[i].items)!)
            let tempPlaylist = collection.items
            var tempPlaylistArray = [appleSongs]()
            for j in 0..<num{
                let song = MPMediaToSong(media: tempPlaylist[j])
                //print(song.title)
                tempPlaylistArray.append(song)
            }
            let playlist = applePlaylist(count: num, title: name, songs: tempPlaylistArray)
            playlistArray.append(playlist)
        }
        //let collection = MPMediaItemCollection(items: (playlists?[0].items)!)
        //let tempcol = collection.items
        //print(tempcol[0].title!)
        
        
        let queryAlbums = MPMediaQuery.albums()
        let albums = queryAlbums.collections
        let albumCount = (albums?.count)!
        for i in 0..<albumCount{
            let num = (albums?[i].count)!
            let collection = MPMediaItemCollection(items: (albums?[i].items)!)
            let tempSongs = collection.items
            var tempSongArray = [appleSongs]()
            for j in 0..<num{
                let song = MPMediaToSong(media: tempSongs[j])
                tempSongArray.append(song)
            }
            let album = appleAlbums(count: num, albumName: tempSongArray[0].album, artwork: tempSongArray[0].artwork, songs: tempSongArray)
            albumArray.append(album)
        }
        
        print(albumArray[1].albumName)
        print(albumArray[1].count)
        print(albumArray[1].songs[1].title)
        
        
        
        appleMusicFetchStorefrontRegion()
        appleMusicPlayTrackId(ids: ["448213995"])
        
        //let albumName = mediaCollection.value(forProperty: MPMediaItemPropertyAlbumTitle)
        //print(albumName)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func MPMediaToSong(media:MPMediaItem) -> appleSongs{
        let playback = Int(media.playbackStoreID)!
        let duration = Int(media.playbackDuration)
        let title = media.title!
        let artist = (media.albumArtist != nil) ? media.albumArtist! : ""
        let album = (media.albumTitle != nil) ? media.albumTitle! : ""
        var artwork: MPMediaItemArtwork? = (media.artwork != nil) ? media.artwork! : nil
        let song = appleSongs(playbackID: playback, duration: duration,title: title, artist: artist, album: album, artwork: artwork)
        return song
    }
    
    func appleMusicPlayTrackId(ids:[String]) {
        print("lololol")
        applicationMusicPlayer.setQueue(with: ids)
        //applicationMusicPlayer.setQueue(with: MPMediaQuery.songs())
        applicationMusicPlayer.play()
        //print(applicationMusicPlayer.shuffleMode)
        //print(applicationMusicPlayer.nowPlayingItem?.title!)
        
    }
    
    func appleMusicFetchStorefrontRegion() {
        
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier {(storefrontId:String?, err:Error?) in
            
            guard err == nil else{
                
                print("An error occured. Handle it here.")
                return
            }
            
            guard let storefrontId = storefrontId , storefrontId.characters.count >= 6 else {
                
                print("Handle the error - the callback didn't contain a valid storefrontID.")
                return
                
            }
            
            let indexRange = storefrontId.index(storefrontId.startIndex, offsetBy: 6)
            let trimmedId = storefrontId.substring(to: indexRange)
            
            print("Success! The user's storefront ID is: \(trimmedId)")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let libraryLabel = cell?.viewWithTag(2) as! UILabel
        libraryLabel.text = tableArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let songCont = storyboard?.instantiateViewController(withIdentifier: "SongsTableViewController") as! SongsTableViewController
            songCont.songArray = songArray
        }
        else if(indexPath.row == 1){
            
        }
        else if(indexPath.row == 2){
            
        }
        else if(indexPath.row == 3){
            
        }
        else{
            print("Tatti")
        }
    }
    
    
    
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let artworkView = cell.viewWithTag(1) as! UIImageView
        let CGsize = CGSize(width: 125, height: 125)
        
//        switch collectionView.tag {
//        case 1:
//            let UIimage = songArray[indexPath.item].artwork?.image(at: CGsize)
//            artworkView.image = UIimage
//        default:
//            print("error in the case")
//        }
        //cell.backgroundColor = model[collectionView.tag][indexPath.item]
        let UIimage = songArray[indexPath.item].artwork?.image(at: CGsize)
        artworkView.image = UIimage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}



