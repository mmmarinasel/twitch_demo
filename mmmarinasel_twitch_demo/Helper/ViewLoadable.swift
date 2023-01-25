import UIKit

protocol ViewLoadable {
    associatedtype MainView: UIView
}

extension ViewLoadable where Self: UIViewController {
    func view() -> MainView {
        guard let view = self.view as? MainView else { return MainView() }
        return view
    }
}
