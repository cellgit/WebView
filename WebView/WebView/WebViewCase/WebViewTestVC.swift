//
//  WebViewTestVC.swift
//  WebView
//
//  Created by 刘宏立 on 2020/7/18.
//

import UIKit
import WebViewJavascriptBridge

class WebViewTestVC: BaseWebViewController {
    
    
//    enum CallbackMethod: String {
//        case login = "Login"
//    }
    
    var bridge: WebViewJavascriptBridge!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        initial()
    }
    
    
    func initial() {
        // 开启日志
        WebViewJavascriptBridge.enableLogging()
        // 给哪个webview建立JS与OjbC的沟通桥梁
        bridge = WebViewJavascriptBridge.init(forWebView: webView)
        bridge.setWebViewDelegate(self)
        // 添加控件
        renderButtons(webView)
        
        // JS主动调用OjbC的方法
        // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
        // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
        // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
        
        bridge.registerHandler("getUserIdFromObjC") { (data, responseCallback) in
            debugPrint("js call getUserIdFromObjC, data from js is \(String(describing: data))")
            
            if responseCallback != nil {
                let dict = ["userId":"123456"]
                // 反馈给JS
                responseCallback?(dict)
            }
        }
        
        bridge.registerHandler("getBlogNameFromObjC") { (data, responseCallback) in
            debugPrint("js call getUserIdFromObjC, data from js is \(String(describing: data))")
            
            if responseCallback != nil {
                let dict = ["blogName":"标哥的技术博客"]
                // 反馈给JS
                responseCallback?(dict)
            }
        }
        
        let dict = ["name":"标哥"]
        bridge.callHandler("getUserInfos", data: dict) { (responseData) in
            debugPrint("from js: \(String(describing: responseData))")
        }
    }
    
    
    func renderButtons(_ webView: WKWebView) {
        let callbackBtn = UIButton.init(type: .roundedRect)
        callbackBtn.addTarget(self, action: #selector(callback), for: .touchUpInside)
        view.insertSubview(callbackBtn, aboveSubview: webView)
        callbackBtn.frame = CGRect(x: 10, y: 400, width: 100, height: 38)
        let font = UIFont.systemFont(ofSize: 12)
        callbackBtn.titleLabel?.font = font
        callbackBtn.setTitle("标题", for: .normal)
        callbackBtn.backgroundColor = .systemBlue
    }
    
    @objc func callback() {
        bridge.callHandler("openWebviewBridgeArticle", data: nil)
    }
    

}
