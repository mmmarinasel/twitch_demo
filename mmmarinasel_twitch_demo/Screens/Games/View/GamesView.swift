import UIKit

final class GamesView: UIView {
    
    public var gamesTableView: UITableView = UITableView()
    private let rowHeight: CGFloat = 140
    
    private var gamesViewModel: GamesViewModel?
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        
        self.gamesViewModel = GamesViewModel()
        self.setup()
        self.gamesViewModel?.games.bind { [weak self] _ in
            self?.gamesTableView.reloadData()
        }
        
        self.gamesViewModel?.presentedItem.bind { [weak self] data in
            let vc = StreamsViewController()
            vc.modalPresentationStyle = .fullScreen
            guard let data = data else { return }
            vc.view. = StreamsViewModel(data ?? <#default value#>)
            self?.present(vc, animated: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.gamesTableView.delegate = self
        self.gamesTableView.dataSource = self
        self.gamesTableView.register(GameTableViewCell.self,
                                     forCellReuseIdentifier: GameTableViewCell.identifier)
        self.addSubview(self.gamesTableView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gamesTableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.gamesTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.gamesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gamesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.gamesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource

extension GamesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
}

extension GamesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gamesViewModel?.games.value??.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier) as? GameTableViewCell
        else { return UITableViewCell() }
        let cellVM = self.gamesViewModel?.getGameCellViewModel(indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
