import Foundation

class StreamsViewModel {
    private let streamsModel: StreamsModel
    var streamCellViewModels: Observable<[StreamCellViewModel]> = Observable([])
    public var streams: Observable<StreamsResponse?> = Observable(nil)
    
    public init(_ game: GameDetails?) {
        self.streamsModel = StreamsModel(game)
        self.streamsModel.fetchData { [weak self] data in
            self?.streams.value = data
            self?.setVMs()
        }
    }
    
    func getStreamCellViewModel(_ indexPath: IndexPath) -> StreamCellViewModel? {
        guard !(streamCellViewModels.value?.isEmpty ?? true) else { return nil }
        return self.streamCellViewModels.value?[indexPath.row]
    }
    
    func setVMs() {
        var vms = [StreamCellViewModel]()
        guard let streams = self.streams.value else { return }
        guard let streamsData = streams?.data else { return }
        for streamData in streamsData {
            vms.append(createStreamCellViewModel(data: streamData))
        }
        self.streamCellViewModels.value = vms
    }
    
    func createStreamCellViewModel(data: Stream) -> StreamCellViewModel {
        let imageUrl = data.thumbnailUrl
        let title = data.title
        let id = data.id
        return StreamCellViewModel(title: title, imageUrl: imageUrl, id: id)
    }
}
