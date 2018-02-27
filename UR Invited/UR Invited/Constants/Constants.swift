//
//  Constants.swift
//  UR Invited
//
//  Created by Valley Technical Academy on 2/5/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation

// MARK: MYSPORTS API Constants
let MYSPORTS_API_USERNAME = "appdevAntonio"
let MYSPORTS_API_PASSWORD = "aguila14"
let MYSPORTS_API_BASE_URL = "https://api.mysportsfeeds.com/v1.2/pull/"
let MYSPORTS_API_CREDETENTIAL_DATA = "\(MYSPORTS_API_USERNAME):\(MYSPORTS_API_PASSWORD)".data(using: String.Encoding.utf8)!
let MYSPORTS_API_BASE64CREDENTIALS = MYSPORTS_API_CREDETENTIAL_DATA.base64EncodedString(options: [])
let MYSPORTS_API_HEADERS = ["Authorization": "Basic \(MYSPORTS_API_BASE64CREDENTIALS)"]
let MYNASCAR_API_HEADERS = ["Ocp-Apim-Subscription-Key": "a43868bb148b4cddaed0cfcfffc56d40"]
let MYNCAABASKETBALL_API_HEADERS = ["Ocp-Apim-Subscription-Key": "2e590fcfe6a14fd7a6dc74c4c12cc8cd"]
let MYNCAAFOOTBALL_API_HEADERS = ["Ocp-Apim-Subscription-Key": "9632ce49a6414514a2c2ee8891a63dd2"]
