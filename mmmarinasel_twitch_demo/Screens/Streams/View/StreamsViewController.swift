import UIKit

class StreamsViewController: UIViewController, ViewLoadable {

    typealias MainView = StreamsView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
    override func loadView() {
        self.view = StreamsView()
    }
}
