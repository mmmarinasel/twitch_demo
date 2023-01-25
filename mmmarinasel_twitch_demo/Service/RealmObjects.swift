import Foundation
import RealmSwift

class RealmGameObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var imageUrl: String = ""
}

class RealmStreamObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var imageUrl: String = ""
}
