//
//  ScriptMessageType.swift
//  WebViewBase
//
//  Created by Trinh Thai on 10/17/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import Foundation

enum ScriptMessageType: String, CaseIterable {
    case loginSucceeded
    case restartApp
}

struct LoginSucceededMessage: Decodable, CustomStringConvertible {
    let account: String?
    let password: String?

    init(account: String?, password: String?) {
        self.account = account
        self.password = password
    }

    var description: String {
        return "account=\(String(describing: account)), password=\(String(describing: password))"
    }
}

struct RestartAppMessage: Decodable, CustomStringConvertible {
    var description: String {
        return ""
    }
}

