//
//  Song.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import Foundation
import UIKit


class Song{
    var name: String
    var artist: String?
    var albumName: String?
    var duration: Int
    var albumImage: UIImage?
    var url: URL
    
    init(name: String, artist: String?, albumName: String?, duration: Int, albumImage: UIImage?, url: URL)
    {
        self.name = name
        self.artist = artist
        self.albumName = albumName
        self.duration = duration
        self.albumImage = albumImage
        self.url = url
    }
}
