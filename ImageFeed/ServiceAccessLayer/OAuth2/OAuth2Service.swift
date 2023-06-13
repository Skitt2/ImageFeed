import UIKit

final class OAuth2Service {
    
    private enum NetworkError: Error {
          case codeError
      }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
                   urlComponents.queryItems = [
                      URLQueryItem(name: "client_id", value: AccessKey),
                      URLQueryItem(name: "client_secret", value: SecretKey),
                      URLQueryItem(name: "redirect_uri", value: RedirectURI),
                      URLQueryItem(name: "code", value: code),
                      URLQueryItem(name: "grant_type", value: "authorization_code")
                    ]
                   let url = urlComponents.url!

                   var request = URLRequest(url: url)
                   request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                completion(.failure(NetworkError.codeError))
            }
            
            guard let data = data else { return }
            
            let apiResponse = try? JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                      guard let apiResponse = apiResponse else {
                          return
            }
            DispatchQueue.main.async {
                completion(.success(apiResponse.accessToken))
                       }
                   }
                   task.resume()
    }
}
