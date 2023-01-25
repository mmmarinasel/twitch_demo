import UIKit

class GameTableViewCell: UITableViewCell {
    
    static let identifier: String = "gameCellId"
    
    private let gameImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cellViewModel: GameCellViewModel? {
        didSet {
            self.gameImageView.image = UIImage(systemName: "photo")
            NetworkManager.loadImageByUrl(urlString: cellViewModel?.imageUrl) { [weak self] img in
                self?.gameImageView.image = img
            }
            self.titleLabel.text = cellViewModel?.title
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.gameImageView)
        let padding: CGFloat = 20
        let constraints = [
            self.gameImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.gameImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                        constant: padding),
            self.gameImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                    constant: padding / 2),
            self.gameImageView.widthAnchor.constraint(equalToConstant: 140),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.gameImageView.trailingAnchor,
                                                     constant: padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                      constant: -padding)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
