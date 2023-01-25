import Foundation

class StreamsModel {
    
    private let networkManager: NetworkManagerProtocol
    private let streamsURLBase: String = "https://api.twitch.tv/helix/streams?game_id="
    public var streams: StreamsResponse?
    private var gameId: String
    
    public init(_ game: GameDetails) {
        self.networkManager = NetworkManager()
        self.gameId = game.id
    }
    
    public func fetchData(completion: @escaping (StreamsResponse?) -> Void) {
        let url = self.streamsURLBase + self.gameId
        self.networkManager.getData(urlString: url) { [weak self] (result: Result<StreamsResponse, Error>) in
            switch result {
            case .success(let data):
                
                self?.streams = self?.replaceImgSize(data)
                completion(self?.streams)
            case .failure(let error):
                print(error)
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
