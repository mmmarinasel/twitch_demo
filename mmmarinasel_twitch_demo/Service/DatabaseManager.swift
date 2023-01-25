import RealmSwift

class DatabaseManager<T: Object> {
    
    public let realm = try! Realm()
    
    func delete(id: String) {
        let items = realm.objects(T.self).filter("id == '\(id)'")
        try! realm.write {
            realm.delete(items)
        }
    }
    
    func add(items: [T]) {
        try! realm.write {
            realm.add(items)
        }
    }
    
    func fetchItems() -> [T] {
        return Array(realm.objects(T.self))
    }
    
    func isAddedItem(_ id: String) -> Bool {
        let item = realm.objects(T.self).filter("id == '\(id)'")
        return !item.isEmpty
    }
}
