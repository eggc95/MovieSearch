import UIKit
import CoreData

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
        private var fetchedResultsController: NSFetchedResultsController<MovieEntity>!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            searchBar.delegate = self
            collectionView.dataSource = self
            collectionView.delegate = self
            
            // Initialize fetched results controller
            fetchedResultsController = initializeFetchedResultsController()
            
            // Perform initial fetch
            performFetch()
        }
        
        func initializeFetchedResultsController() -> NSFetchedResultsController<MovieEntity> {
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                      managedObjectContext: CoreDataManager.shared.managedObjectContext,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
            fetchedResultsController.delegate = self
            
            return fetchedResultsController
        }
        
        func performFetch() {
            do {
                try fetchedResultsController.performFetch()
                collectionView.reloadData()
            } catch {
                print("Failed to fetch movies: \(error)")
            }
        }
        
        func searchMovies(withQuery query: String) {
            guard let url = URL(string: "http://www.omdbapi.com/?apikey=6fc87060&s=\(query)&type=movie") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                    let movies = result.search
                    
                    // Save movies to Core Data
                    CoreDataManager.shared.saveMoviesToCoreData(movies)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }

    extension MovieSearchViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let query = searchBar.text, !query.isEmpty else { return }
            searchMovies(withQuery: query)
            searchBar.resignFirstResponder()
        }
    }

    extension MovieSearchViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
            let movie = fetchedResultsController.object(at: indexPath)
            cell.titleLabel.text = movie.title
            
            if let posterURLString = movie.poster, let posterURL = URL(string: posterURLString) {
                cell.loadImage(from: posterURL)
            }
            
            return cell
        }
    }


    extension MovieSearchViewController: NSFetchedResultsControllerDelegate {
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            collectionView.reloadData()
        }
    }

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewWidth = UIScreen.main.bounds.width
        let itemWidth = collectionViewWidth / 2
        return CGSize(width: itemWidth, height: itemWidth * 2.5) // Adjust the height as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension MovieSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        
        let selectedMovie = fetchedResultsController.object(at: indexPath)
        movieDetailVC.imdbID = selectedMovie.imdbID
        present(movieDetailVC, animated: true, completion: nil)
    }
}


