//
//  Api.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit
import Alamofire
import PromiseKit

class Api: NSObject {
    // this is protocol
    var params: RequestParamters?
    // this is protocol
    var requestType: Requestable?
    var result = ""
    var requestsId = ""

    func getApiName() -> String {
        return ""
    }

    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: ({}))
    }

    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }

    func cancel(requestID : String ) {
        ServiceManager.shared.cancelRequestWithID(requestID: requestID)
    }
}

extension Api {
    func fireRequestWithSingleResponse<T: Codable>(requestable: Requestable , requestId: String = "") -> Promise<T> {
        print(requestable.baseUrl)
        print(requestable.parameters)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<T> { seal in
            
            let completionHandler: (DataResponse<T>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                print(response.data)
                print(response.result.value)
                print(response.response?.statusCode)
                guard response.error == nil else {
                    if (response.error as? URLError) != nil {
                        // no internet connection
                        let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection" , title: "Network Error")
                        seal.reject(errorN)
                        return
                    }
                    
                    if response.response?.statusCode ?? 0 >= 500 {
                        let errorN = CustomError(code: "", message: "Sorry, Internal Server error connection please try again" , title: "Server Error")
                        seal.reject(errorN)
                        return
                    }

                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestId, with: completionHandler)
        }
    }

    func fireRequestWithMultiResponse<T: Codable>(requestable: Requestable) -> Promise<[T]> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<[T]> { seal in
            let completionHandler: (DataResponse<[T]>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                guard response.error == nil else {
                    if let err = response.error as? URLError {
                        // no internet connection
                        let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    debugPrint(response.error)
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithoutResponse(requestable: Requestable) -> Promise<Bool> {
        return Promise<Bool> { seal in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let taskId = beginBackgroundUpdateTask()
            let completionHandler: (DataResponse<Any>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)

                guard response.error == nil else {
                    if let err = response.error as? URLError {
                        // no internet connection
                        let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(response.error!)
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(response.error!)
                    return
                }
                if let result = response.result.value as? [String: Any] {
                    if let _ = result["errors"] {
                        let code = (result["status"] as! NSNumber).stringValue
                        let message = result["message"] as! String
                        let title = result["title"] as! String
                        let error = CustomError(code: code, message: message, title: title)
                        seal.reject(error)
                        return
                    }
                }
                seal.fulfill(true)
            }
            
            
            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithCustomResponse(requestable: Requestable, complition: @escaping (([String: Any]?, CustomError?) -> Void)) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()

        let completionHandler: (DataResponse<Any>) -> Void = { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.endBackgroundUpdateTask(taskID: taskId)
            guard response.error == nil else {
                if let err = response.error as? URLError {
                    // no internet connection
                    let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                    complition(nil, errorN)
                    return
                }
                complition(nil, CustomError.getError(error: response.error!))
                return
            }

            guard response.value != nil else {
                _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                complition(nil, response.error! as? CustomError)
                return
            }

            let result: [String: Any] = response.result.value as? [String: Any] ?? [:]

            if let _ = result["errors"] {
                let code = (result["status"] as! NSNumber).stringValue
                let message = result["message"] as! String
                let title = result["title"] as! String
                let error = CustomError(code: code, message: message, title: title)
                complition(nil, error)
                return
            }

            complition(result, nil)
        }
        requestable.request(requestID: requestsId, with: completionHandler)
    }
}
