//
//  Service.swift
//  PerfectDemo
//
//  Created by 王前 on 2018/10/25.
//  Copyright © 2018年 王前. All rights reserved.
//

import UIKit

let baseServer = "http://127.0.0.1:8181/"

// 根据返回json获取ResponseData数据
public func getResponseData<DataType: Codable>(dataType: DataType.Type, dataJson: String) -> ResponseData<DataType>? {
    let jsonDecoder = JSONDecoder()
    let responseData = try? jsonDecoder.decode(ResponseData<DataType>.self, from: dataJson.data(using: .utf8)!)
    return responseData
}

class Service {
    internal class func postRequest(apiPath: String, params: Dictionary<String, String>, success: @escaping ((_ result: String) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        let url = URL(string: "\(baseServer)\(apiPath)")
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "POST"
        if params.count > 0 {
            var paramList = [String]()
            for param in params {
                let paramStr = "\(param.key)=\(param.value)"
                paramList.append(paramStr)
            }
            let bodyStr = paramList.joined(separator: "&")
            request.httpBody = bodyStr.data(using: .utf8)
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, respons, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    failure(error!)
                    return
                }
                if let data = data {
                    if let result = String(data: data,encoding: .utf8) {
                        success(result)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    internal class func getRequest(apiPath: String, params: Dictionary<String, String>, success: @escaping ((_ result: String) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        var paramsStr = ""
        if params.count > 0 {
            var paramList = [String]()
            for param in params {
                let paramStr = "\(param.key)=\(param.value)"
                paramList.append(paramStr)
            }
            paramsStr = paramList.joined(separator: "&")
        }
        let url = URL(string: "\(baseServer)\(apiPath)?\(paramsStr)")
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, respons, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    failure(error!)
                    return
                }
                if let data = data {
                    if let result = String(data: data,encoding: .utf8) {
                        success(result)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    internal class func downloadImage(imageUrl: String, success: @escaping ((_ image: UIImage?) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        let url = URL(string: imageUrl)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: request) { (location:URL?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                DispatchQueue.main.async {
                    failure(error!)
                }
                return
            }
            print("location:\(location?.absoluteString ?? "")")
            let locationPath = location!.path
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: locationPath))
                DispatchQueue.main.async {
                    success(UIImage(data: data))
                }
            } catch {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        downloadTask.resume()
    }
}
