//
//  OtherExtensionsAndFunctionFile.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 22/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import Foundation

extension String {
    func getWordOfAString() -> String? {
        return self.components(separatedBy: " ").first
    }
}
