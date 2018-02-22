//
//  APIService.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case Success(T)
    case Failure(Int)
}
struct Token {
    static func getUserIndex() -> [String:Int]?{
        let userIdx = UserDefaults.standard.integer(forKey: "userIdx")
        print(userIdx)
        return ["userIdx" : 59]
    }
}

protocol APIService {
    
}

extension APIService  {
    static func getURL(path: String) -> String {
        return "http://45.63.120.140:40004/api/" + path
    }
    static func getResult_StatusCode<T>(response: DataResponse<T>) -> Result<T>? {
        switch response.result {
        case .success :
            guard let statusCode = response.response?.statusCode as Int? else {return nil}
            guard let responseData = response.result.value else {return nil}
            switch statusCode {
            case 200..<400 :
                return Result.Success(responseData)
            default :
                return Result.Failure(statusCode)
            }
        case .failure(let err) :
            print(err.localizedDescription)
        }
        return nil
    }
}
