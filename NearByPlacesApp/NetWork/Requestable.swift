//
//  Requestable.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import Alamofire
import CodableAlamofire

protocol Requestable: URLRequestConvertible {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var header: [String: String]? { get }
    var queryParamters: String? { get }
    var baseUrl: URL { get }
    var parameters: Parameters? { get }
    var timeoutIntervalForRequest: TimeInterval { get }
    var isWWWFormUrlEncoded: Bool? { get }
    
    @discardableResult
    func request<T: Codable>(requestID: String, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest

    @discardableResult
    func request<T: Codable>(requestID: String, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest

    @discardableResult
    func request<T: Any>(requestID: String, with responseDictionryObject: @escaping (DataResponse<T>) -> Void) -> DataRequest
}

extension Requestable {
    // method is post by default 🙄
    var method: Alamofire.HTTPMethod {
        return .post
    }

    // just to add nil as default parameter
    var parameters: Parameters? {
        return nil
    }
    
    var isWWWFormUrlEncoded: Bool? {
        return false
    }

    var queryParamters: String? {
        return nil
    }

    var header: [String: String]? {
        return nil
    }

    // default timeoutIntervalForRequest
    var timeoutIntervalForRequest: TimeInterval {
        return 15.0
    }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseDecodableObject(completionHandler: responseObject).validateErrors()
    }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseDecodableObject(completionHandler: responseArray).validateErrors()
    }

    @discardableResult
    func request<T: Any>(requestID: String, with responseDictionry: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseJSON(completionHandler: responseDictionry as! (DataResponse<Any>) -> Void).validateErrors()
    }

    func asURLRequest() throws -> URLRequest {
        // update timeoutIntervalForRequest from router
        ServiceManager.shared.manager.session.configuration.timeoutIntervalForRequest = timeoutIntervalForRequest

        // MARK: - Get base URL
        var url = baseUrl


        // MARK: - Append endpoint path
        if !path.isEmpty {
        
            url = url.appendingPathComponent(path)
            print(url)
            //.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        }
        

        //MARK: - Append any query parameters if any
        if let extraParams = queryParamters {
            url = url.appendingPathComponent(extraParams)
        }
        
        var urlRequest = try URLRequest(url: url, method: method)

        
        if header != nil {
            for (key, value) in header! {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

//        print("\(url.absoluteString)")

        
//        if let token = UserConfiguration.current.userProfile?.token {
//            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            print("***** Token *****  \(token)")
//        }

        switch method {
        case .get:
            let urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        default:
            if isWWWFormUrlEncoded ?? false {
                let urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
                return urlRequest
            } else {
                let urlRequest = try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
                return urlRequest
            }
        }
    }

//    fileprivate func asURLRequest() -> String {
//        var url = baseUrl
//
//        if !path.isEmpty {
//            url = url.appendingPathComponent(path)
//        }
//
//        return url.absoluteString
//    }
}




