//
//  NetworkError.swift
//  MyCleanProject
//
//  Created by Daehoon Lee on 12/27/24.
//

import Foundation

public enum NetworkError: Error {
    
    // MARK: - Cases
    
    case urlError
    case invalid
    case failToDecode(String)
    case dataNil
    case serverError(Int)
    case requestFailed(String)
    
    // MARK: - Properties
    
    public var description: String {
        switch self {
        case .urlError:
            "URL이 올바르지 않습니다"
        case .invalid:
            "응답값이 유효하지 않습니다"
        case .failToDecode(let description):
            "디코딩 에러 \(description)"
        case .dataNil:
            "데이터가 없습니다"
        case .serverError(let statusCode):
            "서버 에러 \(statusCode)"
        case .requestFailed(let message):
            "서버 요청 실패 \(message)"
        }
    }
}
