//
//  ViewController.swift
//  FitBitIntegration
//
//  Created by Ellina Kuznecova on 31.08.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.get() == nil {
            let url = "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id=227RV6&redirect_uri=fitbitfs%3A%2F%2Ffitbit.com%2Ffitbit_auth&scope=activity&expires_in=31536000"
            
            let vc = SFSafariViewController(URL: NSURL(string: url)!)
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }
    }
}

