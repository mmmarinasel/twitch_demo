import Foundation

class StreamsModel {
    
    private let networkManager: NetworkManagerProtocol
    private let streamsURLBase: String = "https://api.twitch.tv/helix/streams?game_id="
    public var streams: StreamsResponse?
    private var gameId: String
    private let cacheDB: DatabaseManager<RealmStreamObject>
    
    public init(_ game: GameDetails?) {
        self.networkManager = NetworkManager()
        self.cacheDB = DatabaseManager<RealmStreamObject>()
        if let game = game {
            self.gameId = game.id
        } else {
            self.gameId = ""
        }
    }
    
    public func fetchData(completion: @escaping (StreamsResponse?) -> Void) {
        let url = self.streamsURLBase + self.gameId
        
        self.getCached()
        completion(self.streams)
        
        self.networkManager.getData(urlString: url) { [weak self] (result: Result<StreamsResponse, Error>) in
            switch result {
            case .success(let data):
                self?.cache(data)
                self?.streams = self?.replaceImgSize(data)
                completion(self?.streams)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getCached() {
        let realmCached = self.cacheDB.fetchItems()
        var cached: StreamsResponse = StreamsResponse(data: [], pagination: Pagination(cursor: ""))
        for realmItem in realmCached {
            cached.data.append(Stream(id: realmItem.id,
                                      title: realmItem.title,
                                      thumbnailUrl: realmItem.imageUrl))
        }
        self.streams = cached
    }
    
    private func cache(_ streams: StreamsResponse) {
        for stream in streams.data {
            if !cacheDB.isAddedItem(stream.id) {
                let realmObj = RealmStreamObject()
                realmObj.id = stream.id
                realmObj.title = stream.title
                realmObj.imageUrl = stream.thumbnailUrl
                cacheDB.add(items: [realmObj])
            }
        }
    }
    
    private func replaceImgSize(_ streams: StreamsResponse) -> StreamsResponse {
        let sizePattern = "{width}x{height}"
        let sizeActual = "120x140"
        var streamSizes = streams
        for i in 0..<(streamSizes.data.count ) {
            streamSizes.data[i].thumbnailUrl = streamSizes.data[i].thumbnailUrl
                .replacingOccurrences(of: sizePattern, with: sizeActual)
        }
        return streamSizes
    }
}
