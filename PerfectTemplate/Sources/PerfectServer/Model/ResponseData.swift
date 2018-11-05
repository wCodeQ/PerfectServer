//
//  ResponseData.swift
//  PerfectTemplate
//
//  Created by 王前 on 2018/11/5.
//

public struct ResponseData<DataType: Codable>: Codable {
    public var success: Bool
    public var data: DataType
    public var error: MyError?
    
    init(success: Bool, data: DataType, error: MyError?) {
        self.success = success
        self.data = data
        self.error = error
    }
}

public struct MyError: Error, Codable {
    public var code: Int32 = 0
    public var message: String = ""
    public var localizedDescription: String {
        return message
    }
}

// 获取请求response返回body内容
//public func getResponseBodyStr<DataType: Codable>(success: Bool, data: DataType, error: MyError?) -> String {
//    let jsonEncoder: JSONEncoder = JSONEncoder()
//    let responseData = ResponseData(success: true, data: data, error: error)
//    let encoderResponseData = try? jsonEncoder.encode(responseData)
//    let responseDataStr = String(data: encoderResponseData ?? Data(), encoding: .utf8)
//    return responseDataStr ?? ""
//}
