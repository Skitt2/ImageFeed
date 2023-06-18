import Foundation

extension URLSession {

    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fillComplOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fillComplOnMain(.success(result))
                    } catch {
                        fillComplOnMain(.failure(error))
                    }
                } else {
                    fillComplOnMain(.failure(error!))
                }
            } else if let error = error {
                fillComplOnMain(.failure(error))
            } else {
                fillComplOnMain(.failure(error!))
            }
        })
        return task
    }
}
