import UIKit

final class OAuth2Service {

    enum NetworkError: Error {
        case codeError
        case unableToDecodeStringFromData
    }

    private var currentTask: URLSessionTask?
    private var lastCode: String?

    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard let request = makeRequest(code: code) else { return }

        let session = URLSession.shared
        currentTask = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            self.currentTask = nil
            switch result {
            case .success(let oAuthToken):
                handler(.success(oAuthToken.access_token))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code

        currentTask?.resume()
    }

    private func makeRequest(code: String) -> URLRequest? {
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        let params: [String: Any] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        return request
    }
}
