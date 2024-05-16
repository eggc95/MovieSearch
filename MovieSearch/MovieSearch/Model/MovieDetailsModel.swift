import Foundation

struct MovieDetailsModel: Codable {
    let title: String
    let genre: String
    let plot: String
    let imdbRating: String
    let imdbVotes: String
    let poster: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case genre = "Genre"
        case plot = "Plot"
        case imdbRating
        case imdbVotes
        case poster = "Poster"
    }
}
