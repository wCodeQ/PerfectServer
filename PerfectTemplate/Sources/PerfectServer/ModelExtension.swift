//
//  ModelExtension.swift
//  PerfectTemplate
//
//  Created by 王前 on 2018/11/5.
//
import PerfectLib

extension People: JSONConvertible {
    public func jsonEncodedString() throws -> String {
        var dic = [String: Any]()
        dic["name"] = name
        dic["age"] = age
        return try dic.jsonEncodedString()
    }
}

extension ResponseData: JSONConvertible {
    public func jsonEncodedString() throws -> String {
        var dic = [String: Any]()
        dic["success"] = success
        dic["data"] = data
        if error != nil {
            dic["error"] = error
        }
        return try dic.jsonEncodedString()
    }
}

extension MyError: JSONConvertible {
    public func jsonEncodedString() throws -> String {
        var dic = [String: Any]()
        dic["code"] = code
        dic["message"] = message
        return try dic.jsonEncodedString()
    }
}
