//
//  BaseWebViewController.swift
//  WebView
//
//  Created by 刘宏立 on 2020/7/18.
//

import UIKit
import SnapKit
import PKHUD
import WebKit


/*
 超时时长设定(单位/s): web=15s
 */
enum TimeOutEnum {
    case web
    
    var time: TimeInterval {
        switch self {
        case .web: return 15
        }
    }
    var tip: String {
        switch self {
        case .web: return "加载超时,请检查网络连接"
        }
    }
    // 提示显示时间
    var tipDuring: TimeInterval {
        switch self {
        case .web: return 1
        }
    }
}


class BaseWebViewController: UIViewController, WKNavigationDelegate {
    
    open lazy var webView = WKWebView()
    
    private var url: URL!
    
    convenience init(_ url: String) {
        self.init()
        guard let url = URL.init(string: WebUrl.login) else { return }
        self.url = url
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView(url)
    }
    
    func setupWebView(_ url: URL) {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        
        let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeOutEnum.web.time)
        webView.navigationDelegate = self
        
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
        view.addSubview(webView)
        
        layoutWebView()
    }
    
    func layoutWebView() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension BaseWebViewController {
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        debugPrint("=========1111")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("=========222")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("=========333")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("=========444--didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("=========555")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("=========666")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("=========777--didFailProvisionalNavigation")
        HUD.flash(.label(TimeOutEnum.web.tip), delay: TimeOutEnum.web.tipDuring)
    }

    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        debugPrint("=========10")
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        debugPrint("=========11-11--URLAuthenticationChallenge--音视频授权封装")
        
        
    }
    
    
    
    
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        debugPrint("=========888")
//    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        debugPrint("=========999")
//    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//        debugPrint("=========12-12")
//    }

}


