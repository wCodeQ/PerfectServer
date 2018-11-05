//
//  ViewController.swift
//  PerfectDemo
//
//  Created by 王前 on 2018/10/24.
//  Copyright © 2018年 王前. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.logTextView.layoutManager.allowsNonContiguousLayout = false;
    }
    
    private func log(message: String) {
        if self.logTextView.text.count == 0 {
            self.logTextView.text = message
        } else {
            self.logTextView.text = "\(self.logTextView.text!)\n\(message)"
        }
        self.logTextView.scrollRangeToVisible(NSRange(location: self.logTextView.text.count, length: 1))
    }

    @IBAction func addInfoButtonClicked(_ sender: Any) {
        Service.postRequest(apiPath: "insert", params: ["name": "Tom", "age": "15"], success: { (dataStr) in
            self.log(message: dataStr)
        }) { (error) in
            self.log(message: error.localizedDescription)
        }
    }

    @IBAction func queryInfoButtonClicked(_ sender: Any) {
        Service.getRequest(apiPath: "query", params: ["name": "Tom"], success: { (dataStr) in
            self.log(message: dataStr)
            let responseData = getResponseData(dataType: [People].self, dataJson: dataStr)
            print(responseData ?? "返回数据错误")
        }) { (error) in
            self.log(message: error.localizedDescription)
        }
    }
    
    @IBAction func downloadButtonClicked(_ sender: Any) {
        Service.downloadImage(imageUrl: "http://localhost:8181/files/test.jpg", success: { (image) in
            self.imageView.image = image
        }) { (error) in
            self.log(message: error.localizedDescription)
        }
    }
}

