import Foundation

class GamesModel {
    private let networkManager: NetworkManagerProtocol
    private let gamesURL: String = "https://api.twitch.tv/helix/games/top"
    public var games: GamesResponse?
    
    public init() {
        self.networkManager = NetworkManager()
    }
    
    public func fetchData(completion: @escaping (GamesResponse?) -> Void) {
        self.networkManager.getData(urlString: self.gamesURL) { [weak self] (result: Result<GamesResponse, Error>) in
            switch result {
            case .success(let data):
                
                self?.games = self?.replaceImgSize(data)
                completion(self?.games)
            case .failure(let error):
                print(error)
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
