import Foundation

struct GamesResponse: Codable {
    var data: [GameDetails]
    var pagination: Pagination
}

struct StreamsResponse: Codable {
    var data: [Stream]
    var pagination: Pagination
}

struct Stream: Codable {
    var id: String
    var title: String
    var thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case thumbnailUrl = "thumbnail_url"
    }
}

struct Pagination: Codable {
    var cursor: String
}

struct GameDetails: Codable {
    var id: String
    var name: String
    var boxArtUrl: String
    var igdbId: String
    
    enum CodingKeys: String, CodingKey {
        case id,name
        case boxArtUrl = "box_art_url"
        case igdbId = "igdb_id"
    }
}
