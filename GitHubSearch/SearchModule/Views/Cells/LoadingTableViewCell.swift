import UIKit
import NVActivityIndicatorView

class LoadingTableViewCell: UITableViewCell {
  
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    activityIndicator.startAnimating()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
  }
  
}
