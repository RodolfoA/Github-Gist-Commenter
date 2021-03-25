//
//  GistData.swift
//  Github Gist Commenter
//
//  Created by Rodolfo Antoniazzi on 24/03/21.
//

import Foundation

struct GistData : Codable, CustomStringConvertible {
    var url: String?
    
    var description: String {
        if let test = url {
            return test
        }
        return ""
    }
}
