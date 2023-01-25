import Foundation

class GamesViewModel {
    private let gamesModel: GamesModel
    public var gameCellViewModels: Observable<[GameCellViewModel]> = Observable([])
    public var games: Observable<GamesResponse?> = Observable(nil)
    public var presentedItem: Observable<GameDetails?> = Observable(nil)
    private let pagination: Int = 20
    private var paginationOffset: Int = 0
    
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
    
    public func processPagination(_ indexPath: IndexPath) {
        guard indexPath.row % self.pagination == 18 else { return }
        self.paginationOffset += self.pagination
        
        self.gamesModel.paginationFetch(self.paginationOffset) { [weak self] addItems in
            var gamesNew = self?.games.value
            gamesNew??.data.append(contentsOf: addItems?.data ?? [])
            self?.games.value = gamesNew
            self?.setVMs()
        }
    }
    
    func handleTap(_ indexPath: IndexPath) {
        let item = self.games.value??.data[indexPath.row]
        
        self.presentedItem.value = item
    }
}
