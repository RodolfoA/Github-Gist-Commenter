//
//  ViewController.swift
//  Github Gist Commenter
//
//  Created by Rodolfo Antoniazzi on 24/03/21.
//

import UIKit

class GistSelectViewController: UIViewController {
    
    @IBOutlet var linkTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    let rest = RestManager()
    
    let apiBaseURL = "https://api.github.com/gists/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTouchUpInside(_ sender: Any) {
        guard let url = linkTextField.text else {
            return
        }
        getGistInfo(apiURL: getGistAPIURL(gistUrl: url))
    }
    
    func getGistAPIURL(gistUrl: String) -> String {
        var apiURL = apiBaseURL
        if let gistID = gistUrl.components(separatedBy: "/").last {
            apiURL.append(gistID)
        }
        return apiURL
    }
    
    func getGistInfo(apiURL: String) {
        guard apiURL != apiBaseURL else {
            invalidURL()
            return
        }
        guard let url = URL(string: apiURL) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let gistData = try? decoder.decode(GistData.self, from: data), gistData.url != nil else {
                    self.invalidURL()
                    return
                }
                self.gistReturn(data: gistData)
            }
        }
    }
    
    func invalidURL() {
        DispatchQueue.main.async {
            self.errorLabel.text = "Invalid link, please use an Github Gist Link"
            self.errorLabel.isHidden = false
        }
    }
    
    func gistReturn(data: GistData) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
        }
        print(data.description)
    }
    
    @IBAction func unwindToGistSelectViewController(segue: UIStoryboardSegue) {
        if let scannerVC = segue.source as? ScannerViewController, let QRUrl = scannerVC.url {
            getGistInfo(apiURL: getGistAPIURL(gistUrl: QRUrl))
        }
    }
}
