//
//  EpisodeResponse.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 17/10/22.
//

import Foundation

struct EpisodeResponse: Codable {
    var name: String
    var season: Int
    var number: Int
    var summary: String?
    var image: MediaImage?
}

struct MediaImage: Codable {
    let medium: String
    let original: String
}
