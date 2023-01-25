import UIKit

class StreamTableViewCell: UITableViewCell {

    static let identifier: String = "streamCellId"

    private let streamImageView: UIImageView = {
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
    
    var cellViewModel: StreamCellViewModel? {
        didSet {
            self.streamImageView.image = UIImage(systemName: "photo")
            NetworkManager.loadImageByUrl(urlString: cellViewModel?.imageUrl) { [weak self] img in
                self?.streamImageView.image = img
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
        self.contentView.addSubview(self.streamImageView)
        let padding: CGFloat = 20
        let constraints = [
            self.streamImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.streamImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                          constant: padding),
            self.streamImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                      constant: padding / 2),
            self.streamImageView.widthAnchor.constraint(equalToConstant: 140),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.streamImageView.trailingAnchor,
                                                     constant: padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                      constant: -padding)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
