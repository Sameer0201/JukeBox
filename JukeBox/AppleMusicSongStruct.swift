//
//  AppleMusicSongStruct.swift
//  JukeBox
//
//  Created by Nagasaki on 11/02/18.
//  Copyright © 2018 Stone. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import StoreKit

struct appleSongs {
    var playbackID: Int
    var duration: Int
    var title: String
    var artist: String
    var album: String
    var artwork: MPMediaItemArtwork?
    
    init(playbackID: Int, duration: Int, title: String, artist: String, album: String, artwork: MPMediaItemArtwork?){
        self.playbackID = playbackID
        self.duration = duration
        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}

struct appleArtists {
    var count: Int
    var artistId : String
    var artistName: String
    var songs = [appleSongs]()
    
    init(count: Int, artistId: String, artistName: String, songs: [appleSongs]){
        self.count = count
        self.artistId = artistId
        self.artistName = artistName
        self.songs = songs
    }
}

struct appleAlbums {
    var count: Int
    var albumName: String
    var artwork: MPMediaItemArtwork?
    var songs = [appleSongs]()
    
    init(count: Int, albumName: String, artwork: MPMediaItemArtwork?, songs: [appleSongs]){
        self.count = count
        self.albumName = albumName
        self.artwork = artwork
        self.songs = songs
    }
}

struct applePlaylist {
    var count: Int
    var title: String
    var songs = [appleSongs]()
    
    init(count: Int, title: String, songs: [appleSongs]){
        self.count = count
        self.title = title
        self.songs = songs
    }
}

