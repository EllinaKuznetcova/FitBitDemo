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
    
    var todaySteps: Steps?
    var interSteps: [Steps] = []
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.get() {
            Logger.debug(user.fitbitToken)
        }
        else {
            let url = "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id=227RV6&redirect_uri=fitbitfs%3A%2F%2Ffitbit.com%2Ffitbit_auth&scope=activity&expires_in=31536000"
            
            let vc = SFSafariViewController(URL: NSURL(string: url)!)
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }
        
        self.getSteps()
    }
    
    func getSteps() {
        Router.Steps.GetToday.request().responseObject { [weak self] (response: Response<RTStepsResponse, RTError>) in
            switch response.result {
            case .Success(let value):
                self?.todaySteps = value.stepsPerDay
                self?.interSteps = value.stepsIntraday
                self?.tableView.reloadData()
            case .Failure(let error):
                Logger.error("\(error)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todaySteps == nil ? self.interSteps.count : self.interSteps.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let startDate: NSDate
        let endDate: NSDate
        let numberOfSteps: Int
        if let lTodaySteps = self.todaySteps {
            if indexPath.row == 0 {
                startDate = lTodaySteps.startDate
                endDate = lTodaySteps.endDate
                numberOfSteps = lTodaySteps.count
            }
            else {
                let interStep = self.interSteps[indexPath.row-1]
                startDate = interStep.startDate
                endDate = interStep.endDate
                numberOfSteps = interStep.count
            }
        }
        else {
            let interStep = self.interSteps[indexPath.row]
            startDate = interStep.startDate
            endDate = interStep.endDate
            numberOfSteps = interStep.count
        }
        
        cell.textLabel!.text = "\(numberOfSteps) steps"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(startDate) + " " + dateFormatter.stringFromDate(endDate)
        
        return cell
    }
}
