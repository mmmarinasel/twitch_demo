import Foundation
import UIKit.UIImage

protocol NetworkManagerProtocol {
    func getData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)
}

protocol ImageLoaderProtocol {
    static func loadImageByUrl(urlString: String?, completion: @escaping (UIImage) -> Void)
}

class NetworkManager: NetworkManagerProtocol, ImageLoaderProtocol {

    private func getJson(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer fpwtd30kkaa5lsjgoe9814dra5nxc4", forHTTPHeaderField: "Authorization")
        request.setValue("dqa46yk7jedbmjwpk35hyj4isv3dqb", forHTTPHeaderField: "Client-Id")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }

    func getData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        self.getJson(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(json))
                }
            } catch {
                print(error.localizedDescription)
                print(error)
                completion(.failure(error))
            }
        }
    }

    static func loadImageByUrl(urlString: String?, completion: @escaping (UIImage) -> Void) {
        guard let urlString = urlString else { return }
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
               let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
