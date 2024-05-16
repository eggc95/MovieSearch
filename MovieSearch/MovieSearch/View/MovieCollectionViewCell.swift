import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var task: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadImage(from url: URL) {
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }
        
        task?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        task?.cancel()
    }
}
