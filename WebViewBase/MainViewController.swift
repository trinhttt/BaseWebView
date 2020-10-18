//
//  HomeViewController.swift
//  WebViewBase
//
//  Created by Trinh Thai on 10/18/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: BaseWebViewViewController {

    @IBOutlet weak var ibToolBar: UIToolbar!
    @IBOutlet weak var ibRewindButton: UIBarButtonItem!
    @IBOutlet weak var ibForwardButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.contentInset.bottom = ibToolBar.bounds.size.height
        
        // If do not this code, scroll indicator is hiden a part
        webView.scrollView.verticalScrollIndicatorInsets.bottom = ibToolBar.bounds.size.height
        
        // Horizontal swipe gestures (vuot ngang) will trigger back-forward list navigations
        webView.allowsBackForwardNavigationGestures = true
        
        ibRewindButton.isEnabled = webView.canGoBack
        ibForwardButton.isEnabled = webView.canGoForward
        self.load(urlString: "https://apple.com/")

    }
    
    @IBAction func ibCloseTapped(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ibRewindTapped(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func ibForwardTapped(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}

extension MainViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ibRewindButton.isEnabled = webView.canGoBack
        ibForwardButton.isEnabled = webView.canGoForward
        if webView.url?.absoluteString.contains("https://.../home1") == true {
           self.navigationItem.title = "HOME"
            return
        }
        self.navigationItem.title = webView.title
    }
}
