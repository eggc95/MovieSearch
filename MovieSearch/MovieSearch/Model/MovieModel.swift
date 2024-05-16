struct Movie: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

struct MovieSearchResponse: Codable {
    let search: [Movie]
    let totalResults: String
    let response: String
    
    private enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
