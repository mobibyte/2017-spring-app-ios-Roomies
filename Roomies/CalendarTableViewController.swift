//
//  CalendarTableViewController.swift
//  Roomies
//
//  Created by Matthew Mcleod on 10/28/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import GoogleAPIClient
import GTMOAuth2
import UIKit

class CalendarTableViewController: UITableViewController {
    
    private let kKeychainItemName = "Roomies"
    private let kClientID = "597883647302-he11sqgja1gbmskp1prjr2fgunfe323g.apps.googleusercontent.com"
    // private let kClientID = "4/t0ENw_F_F1PffLKhXI_i0Pta4tup1Ywhq-GgoH12Hcg"
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    
    private let service = GTLServiceCalendar()
    let output = UITextView()
    
    var events : [GTLCalendarEvent] = []
    var authController: GTMOAuth2ViewControllerTouch?
    var autoTriedAuth = false
    
    
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseViewControllerUtil.setup(viewController: self)
        
        //output.frame = view.bounds
        //output.isEditable = false
        //output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        //output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //view.addSubview(output);
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
    }
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
    override func viewDidAppear(_ animated: Bool) {
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize, canAuth {
            fetchEvents()
        } else {
            if !self.autoTriedAuth {
                self.present(
                    createAuthController(),
                    animated: true,
                    completion: nil
                )
                self.autoTriedAuth = true
            }
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLQueryCalendar.queryForEventsList(withCalendarId: "primary")
        query?.maxResults = 10
        query?.timeMin = GTLDateTime(date: NSDate() as Date!, timeZone: NSTimeZone.local)
        query?.singleEvents = true
        query?.orderBy = kGTLCalendarOrderByStartTime
        service.executeQuery(
            query!,
            delegate: self,
            //didFinish: Selector(("displayResultWithTicket:finishedWithObject:error:"))
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket (
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        
        if let events = response.items(), !events.isEmpty {
            self.events = events as! [GTLCalendarEvent]
            self.tableView.reloadData()
            
            /*for event in events as! [GTLCalendarEvent] {
             let start : GTLDateTime! = event.start.dateTime ?? event.start.date
             print(start)
             let startString = DateFormatter.localizedString(
             from: start.date,
             dateStyle: .short,
             timeStyle: .short
             )
             names.append(event.eTag)
             times.append(startString)
             descs.append(event.summary)
             
             }*/
        } else {
            //names.append("No events found")
        }
        
        //reloadInputViews()
    }
    
    
    // Creates the auth controller for authorizing access to Google Calendar API
    private func createAuthController() -> UIViewController {
        let scopeString = scopes.joined(separator: "")
        self.authController = GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: Selector(("viewController:finishedWithAuth:error:"))
        )
        let navController = UINavigationController(rootViewController: authController!)
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        let navItems = UINavigationItem(title: "Login with Google")
        navItems.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelGoogleLogin))
        navbar.items = [navItems]
        
        navController.view.addSubview(navbar)
        
        
        return navController
    }
    
    func cancelGoogleLogin() {
        print("PRESSED CANCEL")
        self.authController?.cancelSigningIn()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Handle completion of the authorization process, and update the Google Calendar API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if error != nil {
            service.authorizer = nil
            showAlert(title: "Authentication Error", message: (error?.localizedDescription)!)
            return
        }
        
        service.authorizer = authResult
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarTableViewCell
        
        let event = self.events[indexPath.row]
        
        cell.eventName.text = event.eTag
        cell.eventDatetime.text = event.start.dateTime.stringValue
        cell.eventDescription.text = event.summary
        
        print("TRYING TO CREATE")
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Alert popup
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        self.present(alert, animated:true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
