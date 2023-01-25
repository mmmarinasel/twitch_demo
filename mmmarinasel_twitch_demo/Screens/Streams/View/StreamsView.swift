import UIKit

class StreamsView: UIView {
    
    public var streamsTableView: UITableView = UITableView()
    private let rowHeight: CGFloat = 140
    private var streamsViewModel: StreamsViewModel?
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.streamsViewModel = StreamsViewModel()
        self.setup()
        self.streamsViewModel?.streams.bind { [weak self] _ in
            self?.streamsTableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.streamsTableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.streamsTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.streamsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.streamsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.streamsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setup() {
        self.streamsTableView.delegate = self
        self.streamsTableView.dataSource = self
        self.streamsTableView.register(StreamTableViewCell.self,
                                     forCellReuseIdentifier: StreamTableViewCell.identifier)
        self.addSubview(self.streamsTableView)
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource

extension StreamsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
}

extension StreamsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.streamsViewModel?.streams.value??.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StreamTableViewCell.identifier) as? StreamTableViewCell
        else { return UITableViewCell() }
        let cellVM = self.streamsViewModel?.getStreamCellViewModel(indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
