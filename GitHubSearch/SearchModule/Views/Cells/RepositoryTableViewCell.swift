import Foundation
import UIKit

let maxStringLength = 30

class RepositoryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var viewedLabel: UILabel!
  
  var model: Repository? {
    didSet {
      updateUI()
    }
  }
  
  func updateUI() {
    guard let repository = model else { return }
    nameLabel.text = repository.name.count > maxStringLength ?  String(repository.name.prefix(maxStringLength) + "[TRUNCATED]") : repository.name
    idLabel.text = "\(repository.id)"
    viewedLabel.isHidden = !repository.isViewed
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewedLabel.isHidden = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    nameLabel.text = nil
  }
  
}
