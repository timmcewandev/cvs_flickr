//
//  FlickrItem.swift
//  CVS_flickr
//
//  Created by Tim McEwan on 3/26/25.
//

import Foundation

struct FlickrItem: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let description: String
    let modified: Date?
    let generator: String
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case description
        case modified = "dc:date"
        case generator
        case items
    }
    
    struct Item: Decodable {
        let title: String?
        let link: String?
        let media: Media
        let dateTaken: Date?
        let description: String?
        let published: Date?
        let author: String?
        let tags: String?
        
        enum CodingKeys: String, CodingKey {
            case title
            case link
            case media
            case dateTaken = "date_Taken"
            case description
            case published
            case author
            case tags
        }
    }
    struct Media: Decodable {
        let m: String
    }
}
