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
    func fireRequestWithSingleResponse<T: Codable>(
        requestable: Requestable,
        requestId: String = ""
    ) -> Promise<T> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<T> { seal in
            
            let completionHandler: (DataResponse<T>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                guard response.error == nil else {
                    seal.reject(response.error!)
                    return
                }
                guard response.value != nil else {
                    seal.reject( response.error!)
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestId, with: completionHandler)
        }
    }

    func handleResponse() {
        
    }
}
