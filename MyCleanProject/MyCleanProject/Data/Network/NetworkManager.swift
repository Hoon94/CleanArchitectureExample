//
//  NetworkManager.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/29/24.
//

import Alamofire
import Foundation

public class NetworkManager {
    
    // MARK: - Properties
    
    private let session: SessionProtocol
    private let tokenHeader: HTTPHeaders = {
        let tokenHeader = HTTPHeader(name: "Authorization", value: "Bearer <YOUR-TOKEN>")
        
        return HTTPHeaders([tokenHeader])
    }()
    
    // MARK: - Lifecycle
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    // MARK: - Helpers
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else {
            return .failure(.urlError)
        }
        
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response
        
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription)) }
        guard let data = result.data else { return .failure(.dataNil) }
        guard let response = result.response else { return .failure(.invalidResponse) }
        guard 200..<400 ~= response.statusCode else { return .failure(.serverError(response.statusCode)) }
        
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            
            return .success(data)
        } catch {
            return .failure(.failToDecode(error.localizedDescription))
        }
    }
}
