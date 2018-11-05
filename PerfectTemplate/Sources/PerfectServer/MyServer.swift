//
//  MyServer.swift
//  PerfectTemplate
//
//  Created by 王前 on 2018/8/28.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Darwin

let insertAPI = "/insert"
let queryAPI = "/query"
let deleteAPI = "/delete"

open class MyServer {
    
    fileprivate var server: HTTPServer
    fileprivate var myDB = MyDB.init()
    
    internal init(root: String, port: UInt16) {
        //构造 HTTPServer 对象
        server = HTTPServer.init()
        //构造路由对象，这只是个容器，现在这里面并没有内容
        var routes = Routes.init()
        //配置路由，添加URL以及回调函数
        configure(routes: &routes)
        //将路由添加进服务
        server.addRoutes(routes)
        //设置端口和根目录
        server.serverPort = port
        server.documentRoot = root
    }
    
    //配置路由函数
    fileprivate func configure(routes: inout Routes) {
        //添加接口，路径为/，方法为GET，回调函数为闭包
        /**
         请求首页
         **/
        routes.add(method: .get, uri: "/", handler: { request, response in
            //返回数据头
            response.setHeader(.contentType, value: "text/html")
            //返回数据体
            StaticFileHandler(documentRoot: "\(request.documentRoot)").handleRequest(request: request, response: response)
            //返回
            response.completed()
        })
        /**
         请求图片
         **/
        routes.add(method: .get, uri: "/files/*", handler: { request, response in
            //返回数据头
            response.setHeader(.contentType, value: "image/*")
            //返回数据体
            StaticFileHandler(documentRoot: "\(request.documentRoot)/..").handleRequest(request: request, response: response)
            //返回
            response.completed()
        })
        /**
         插入数据
         **/
        routes.add(method: .post, uri: insertAPI) { (request, response) in
            //取得url中的参数，类型是`[(String, String)]`，遍历即可
            let params = request.params()
            var column = [String]()
            var columnValue = [String]()
            params.forEach({ (param) in
                column.append(param.0)
                if param.0 == "name" {
                    columnValue.append("'\(param.1)'")
                } else {
                    columnValue.append(param.1)
                }
            })
            let sqlText = "insert into people(\(column.joined(separator: ","))) values(\(columnValue.joined(separator: ",")))"
            print(sqlText)
            self.myDB.connectDB()
            do {
                try self.myDB.query(sqlText: sqlText)
                print("插入数据成功")
                let responseData = ResponseData(success: true, data: "插入数据成功", error: nil)
                let json = try responseData.jsonEncodedString()
                response.setBody(string: json)
//                response.setBody(string: getResponseBodyStr(success: true, data: "插入数据成功", error: nil))
            } catch {
                print("插入数据失败")
                let errorData = ResponseData(success: false, data: [People](), error: error as? MyError)
                let json = try? errorData.jsonEncodedString()
                response.setBody(string: json ?? "")
            }
            response.completed()
            self.myDB.closeDB()
        }
        /**
         查询数据
         **/
        routes.add(method: .get, uri: queryAPI) { (request, response) in
            let params = request.params()
            var condition = [String]()
            params.forEach({ (param) in
                if param.0 == "name" {
                    condition.append("name='\(param.1)'")
                } else {
                    condition.append("age=\(param.1)")
                }
            })
            let conditionSQL = condition.joined(separator: " and ")
            let sqlText = "select * from people where \(conditionSQL)"
            print(sqlText)
            self.myDB.connectDB()
            do {
                try self.myDB.query(sqlText: sqlText)
                if let data = self.myDB.getSelectData() {
                    let responseData = ResponseData(success: true, data: data, error: nil)
                    let json = try responseData.jsonEncodedString()
                    response.setBody(string: json)
//                    response.setBody(string: getResponseBodyStr(success: true, data: data, error: nil))
                }
            } catch {
                let errorData = ResponseData(success: false, data: [People](), error: error as? MyError)
                let json = try? errorData.jsonEncodedString()
                response.setBody(string: json ?? "")
//                response.setBody(string: getResponseBodyStr(success: false, data: [People](), error: error as? MyError))
            }
           
            response.completed()
            self.myDB.closeDB()
        }
    }
    
    //开始服务
    open func start() {
        do {
            try self.server.start()
        } catch PerfectError.networkError(let err, let msg) {
            print("Network error thrown: \(err) \(msg)")
        } catch {
            print("Network unknow error")
        }
    }
}
