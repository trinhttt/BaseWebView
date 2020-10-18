//
//  BaseWebViewViewController.swift
//  WebViewBase
//
//  Created by Trinh Thai on 10/17/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewViewController: UIViewController, WKUIDelegate {
    
    lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        
        // Add scrip message handler
        // BUT WKUserContentController retains its message handler CAUSE LEAKING: https://stackoverflow.com/questions/26383031/wkwebview-causes-my-view-controller-to-leak
        ScriptMessageType.allCases.forEach { type in
            userContentController.add(self, name: type.rawValue)
        }
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        let webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white// app's background
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // app's background
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        //moves the specified view(here: webView) to the beginning of the array of views in the subviews property.
        view.sendSubviewToBack(webView)
        let leftConstraint = webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let rightConstraint = webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let topConstraint = webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottomConstraint = webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        view.updateConstraintsIfNeeded()
    }
    
    func load(urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("ignore url. url=\(urlString)")
        }
        webView.load(URLRequest(url: url))
    }
}

extension BaseWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, url.scheme == "appli", url.path == "/login" {
                // do sth
                decisionHandler(.cancel)
                return
            }
            if let url = navigationAction.request.url, url.scheme == "appli", url.path == "/home" {
                // do sth
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}

extension BaseWebViewViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let script = ScriptMessageType(rawValue: message.name) else {
            return
        }

        do {
            switch script {
            case .loginSucceeded:
                let body = try decodeMessageBody(message: message) as LoginSucceededMessage
                print(body)
            case .restartApp:
                let body = try decodeMessageBody(message: message) as RestartAppMessage
                print(body)
            }
        } catch {
            print(error)
        }
    }
    
    private func decodeMessageBody<T: Decodable>(message: WKScriptMessage) throws -> T {
        let body = message.body as! String
        let jsonData = body.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: jsonData)
    }
}
