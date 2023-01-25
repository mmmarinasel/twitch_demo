import Foundation

class GamesModel {
    private let networkManager: NetworkManagerProtocol
    private let gamesURLBase: String = "https://api.twitch.tv/helix/games/top?"
    public var games: GamesResponse?
    private let cacheDB: DatabaseManager<RealmGameObject>
    
    public init() {
        self.networkManager = NetworkManager()
        self.cacheDB = DatabaseManager<RealmGameObject>()
    }
    
    public func fetchData(completion: @escaping (GamesResponse?) -> Void) {
        
        self.getCached()
        completion(self.games)
        self.networkManager.getData(urlString: self.gamesURLBase) { [weak self] (result: Result<GamesResponse, Error>) in
            switch result {
            case .success(let data):
                self?.cache(data)
                self?.games = self?.replaceImgSize(data)
                completion(self?.games)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func paginationFetch(_ paginationOffset: Int, completion: @escaping (GamesResponse?) -> Void) {
        let url = self.gamesURLBase + "from=\(paginationOffset)"
        self.networkManager.getData(urlString: url) { [weak self] (result: Result<GamesResponse, Error>) in
            switch result {
            case .success(let data):
                self?.cache(data)
                let addGames = self?.replaceImgSize(data)
                completion(addGames)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getCached() {
        let realmCached = self.cacheDB.fetchItems()
        var cached: GamesResponse = GamesResponse(data: [], pagination: Pagination(cursor: ""))
        for realmItem in realmCached {
            cached.data.append(GameDetails(id: realmItem.id,
                                           name: realmItem.title,
                                           boxArtUrl: realmItem.imageUrl,
                                           igdbId: ""))
        }
        self.games = cached
    }
    
    private func cache(_ games: GamesResponse) {
        for game in games.data {
            if !cacheDB.isAddedItem(game.id) {
                let realmObj = RealmGameObject()
                realmObj.id = game.id
                realmObj.title = game.name
                realmObj.imageUrl = game.boxArtUrl
                cacheDB.add(items: [realmObj])
            }
        }
    }
    
    private func replaceImgSize(_ games: GamesResponse) -> GamesResponse {
        let sizePattern = "{width}x{height}"
        let sizeActual = "120x140"
        var gamesSizes = games
        for i in 0..<(gamesSizes.data.count ) {
            gamesSizes.data[i].boxArtUrl = gamesSizes.data[i].boxArtUrl
                .replacingOccurrences(of: sizePattern, with: sizeActual)
        }
        return gamesSizes
    }
}
