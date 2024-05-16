import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var imdbVotesLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    var imdbID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imdbID = imdbID {
            fetchMovieDetails(imdbID: imdbID)
        }
    }
    
    func fetchMovieDetails(imdbID: String) {
        guard let url = URL(string: "https://www.omdbapi.com/?apikey=6fc87060&i=\(imdbID)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetailsModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.updateUI(with: movieDetail)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func updateUI(with movieDetail: MovieDetailsModel) {
        titleLabel.text = movieDetail.title
        genreLabel.text = movieDetail.genre
        plotLabel.text = movieDetail.plot
        imdbRatingLabel.text = "IMDb Rating: \(movieDetail.imdbRating)"
        imdbVotesLabel.text = "IMDb Votes: \(movieDetail.imdbVotes)"
        if let posterURL = URL(string: movieDetail.poster) {
            loadImage(from: posterURL)
        }
    }
    
    func loadImage(from url: URL) {
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }
               DispatchQueue.main.async {
                   self.poster.image = UIImage(data: data)
               }
           }.resume()
       }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
           dismiss(animated: true, completion: nil)
       }
}
