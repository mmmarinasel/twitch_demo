import UIKit

final class GamesViewController: UIViewController, ViewLoadable {

    typealias MainView = GamesView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
    }
    
    override func loadView() {
        self.view = GamesView()
    }
}

