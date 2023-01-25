import UIKit

final class GamesViewController: UIViewController, ViewLoadable {

    typealias MainView = GamesView
    private var gamesViewModel: GamesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        
        self.gamesViewModel?.presentedItem.bind { [weak self] data in
            let vc = StreamsViewController()
            guard let data = data else { return }
            vc.game = data
            self?.present(vc, animated: true)
        }
    }
    
    override func loadView() {
        self.gamesViewModel = GamesViewModel()
        guard let vm = self.gamesViewModel else { return }
        self.view = GamesView(vm: vm)
    }
}

