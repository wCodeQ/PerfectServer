//
//  MyDB.swift
//  PerfectTemplate
//
//  Created by 王前 on 2018/8/30.
//

import PerfectMySQL

open class MyDB {
    
    let testHost = "127.0.0.1"
    let testUser = "root"
    let testPassword = "12345678"
    let testDB = "new_schema"
    
    var isConnect: Bool {
        get {
            return self.mysql != nil
        }
    }
    
    private var mysql: MySQL?
    
    func connectDB() {
        mysql = MySQL.init()
        let connected = mysql!.connect(host: testHost, user: testUser, password: testPassword, db: testDB)
        guard connected else {
            // 验证一下连接是否成功
            print(mysql!.errorMessage())
            mysql = nil
            return
        }
        print("数据库连接成功");
    }
    
    func closeDB() {
        mysql = nil;
    }
    
    func selectDB(name: String) {
        if mysql == nil {
            self.connectDB()
        }
        guard let mysql = mysql else {
            print("数据库未连接")
            return
        }
        guard mysql.selectDatabase(named: name) else {
            print("数据库选择失败。错误代码：\(mysql.errorCode()) 错误解释：\(mysql.errorMessage())")
            return;
        }
        print("连接schema：\(name)成功");
    }
    
    // 获取查询数据方法
    func getSelectData() -> [People]? {
        guard let results = mysql?.storeResults() else {
            return nil
        }
        var ary = [People]() //创建一个字典数组用于存储结果
        results.forEachRow { row in
            let name = row.count > 1 ? row[1]:nil //第0个是id，不需要，所以从1开始
            let age = row.count > 2 ? row[2]:nil
            if name != nil && age != nil {
                ary.append(People(name: name!, age: Int(age!)!))
            }
        }
        return ary
    }
    
    // 增删改查语句执行
    func query(sqlText: String) throws {
        if mysql == nil {
            self.connectDB()
        }
        guard let mysql = mysql else {
            print("数据库未连接")
            let error = MyError(code: -1, message: "数据库未连接")
            throw error
        }
        // 执行语句
        if mysql.query(statement: sqlText) {
        } else {
            let error = MyError(code: Int32(mysql.errorCode()), message: mysql.errorMessage())
            throw error
        }
    }
}
