import Foundation

class GamesViewModel {
    private let gamesModel: GamesModel
    public var gameCellViewModels: Observable<[GameCellViewModel]> = Observable([])
    public var games: Observable<GamesResponse?> = Observable(nil)
    public var presentedItem: Observable<GameDetails?> = Observable(nil)
    
    public init() {
        self.gamesModel = GamesModel()
        self.gamesModel.fetchData { [weak self] data in
            self?.games.value = data
            self?.setVMs()
        }
    }
    
    func getGameCellViewModel(_ indexPath: IndexPath) -> GameCellViewModel? {
        guard !(gameCellViewModels.value?.isEmpty ?? true) else { return nil }
        return self.gameCellViewModels.value?[indexPath.row]
    }
    
    func setVMs() {
        var vms = [GameCellViewModel]()
        guard let games = self.games.value else { return }
        guard let gamesData = games?.data else { return }
        for gameData in gamesData {
            vms.append(createGameCellViewModel(data: gameData))
        }
        self.gameCellViewModels.value = vms
    }
    
    func createGameCellViewModel(data: GameDetails) -> GameCellViewModel {
        let imageUrl = data.boxArtUrl
        let title = data.name
        let id = data.id
        return GameCellViewModel(title: title, imageUrl: imageUrl, id: id)
    }
    
    func handleTap(_ indexPath: IndexPath) {
        self.presentedItem.value = self.games.value??.data[indexPath.row]
    }
}
