import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var poster: String?
    @NSManaged public var year: String?
    @NSManaged public var imdbID: String?
    
    func configure(with movie: Movie) {
            self.title = movie.title
            self.poster = movie.poster
            self.year = movie.year
            self.imdbID = movie.imdbID
        }

}

extension MovieEntity : Identifiable {

}
