import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private var getProfileImageTask: URLSessionTask?
    private var lastProfileImageCode: String?

    private (set) var avatarURL: URL?
    let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private enum GetProfileImageError: Error {
        case profileImageCodeError
        case unableToDecodeStringFromProfileImageData
        case noURL
    }

    struct UserResult: Decodable {
        let profileImage: [String: String]

        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }

    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<URL, Error>) -> Void) {
        assert(Thread.isMainThread)

        let request = makeRequest(username, token)

        let session = URLSession.shared

        getProfileImageTask = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            self.getProfileImageTask = nil
            switch result {
            case .success(let userResult):
                guard let profileImageURL = userResult.profileImage["small"],
                      let avatarURL = URL(string: profileImageURL) else {
                    completion(.failure(GetProfileImageError.noURL))
                    return
                }
                self.avatarURL = avatarURL
                NotificationCenter.default.post(
                    name: self.didChangeNotification,
                    object: nil)
                completion(.success(avatarURL))
            case .failure(_):
                completion(.failure(GetProfileImageError.unableToDecodeStringFromProfileImageData))
                self.lastProfileImageCode = nil
                return
            }
        }
        getProfileImageTask?.resume()
    }

    private func makeRequest(_ username: String,_ token: String) -> URLRequest {

        var request = URLRequest(url: Constants.defaultBaseURL.appendingPathComponent("users/\(username)"))
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }

}
