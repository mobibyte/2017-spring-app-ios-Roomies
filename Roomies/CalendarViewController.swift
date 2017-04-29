//
//  CalendarViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 4/7/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import GoogleAPIClient
import GTMOAuth2
import UIKit
import JTCalendar

class CalendarViewController: UIViewController, JTCalendarDelegate {

    @IBOutlet weak var calendarView: JTVerticalCalendarView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var weekDayView: JTCalendarWeekDayView!
    var calendarManager: JTCalendarManager!
    
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
    
    
    var dateSelected: Date?
    //var calendarManager:
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        calendarManager.settings.pageViewHaveWeekDaysView = false
        calendarManager.settings.pageViewNumberOfWeeks = 0
        calendarView.manager = calendarManager
        
        weekDayView.manager = calendarManager
        weekDayView.reload()
        
        calendarManager.menuView = self.calendarMenuView
        calendarManager.contentView = self.calendarView
        calendarManager.setDate(Date())
        
        calendarMenuView.scrollView.isScrollEnabled = false
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
        
    }
    
    public func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        let myDayView = dayView as! JTCalendarDayView
        myDayView.isHidden = false
        
        if myDayView.isFromAnotherMonth {
            myDayView.isHidden = true
        } else if calendarManager.dateHelper.date(Date(), isTheSameDayThan: myDayView.date) {
            myDayView.circleView.isHidden = false
            myDayView.circleView.backgroundColor = UIColor.blue
            myDayView.dotView.backgroundColor = UIColor.white
            myDayView.textLabel?.textColor = UIColor.white
        } else if (dateSelected != nil) && calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: myDayView.date) {
            myDayView.circleView.isHidden = false
            myDayView.circleView.backgroundColor = UIColor.red
            myDayView.dotView.backgroundColor = UIColor.white
            myDayView.textLabel?.textColor = UIColor.white
        }  else if !calendarManager.dateHelper.date(calendarView.date, isTheSameMonthThan: myDayView.date) {
            myDayView.circleView.isHidden = true
            myDayView.dotView.backgroundColor = UIColor.red
            myDayView.textLabel?.textColor = UIColor.lightGray
        } else {
            myDayView.circleView.isHidden = true
            myDayView.dotView.backgroundColor = UIColor.red
            myDayView.textLabel?.textColor = UIColor.black
        }
        
        if haveEvent(forDay: myDayView.date ) {
            myDayView.dotView.isHidden = false
            print("You had an event")
        }
        else {
            myDayView.dotView.isHidden = true
        }
    }
    
    public func calendar(_ calendar: JTCalendarManager, didTouch dayView: UIView!) {
        let myDayView = dayView as! JTCalendarDayView
        
        dateSelected = myDayView.date
        // Animation for the circleView
        myDayView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        UIView.transition(with: myDayView, duration: 0.3, options: [], animations: {() -> Void in
            myDayView.circleView.transform = CGAffineTransform.identity
            self.calendarManager.reload()
        }, completion: { _ in })
        // Don't change page in week mode because block the selection of days in first and last weeks of the month
        if calendarManager.settings.weekModeEnabled {
            return
        }
        // Load the previous or next page if touch a day from another month
        if !calendarManager.dateHelper.date(calendarView.date, isTheSameMonthThan: myDayView.date) {
            if calendarView.date?.compare(myDayView.date) == .orderedAscending {
                calendarView.loadNextPageWithAnimation()
            }
            else {
                calendarView.loadPreviousPageWithAnimation()
            }
        }
    }
    
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
            didFinish: #selector(assigningEvents(ticket:finishedWithObject:error:))
        )

    }
    
    func assigningEvents (
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        
        if let events = response.items(), !events.isEmpty {
            self.events = events as! [GTLCalendarEvent]
            
        }
    }
    
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
    
    func dateFormatter() -> DateFormatter {
        var dateFormatter: DateFormatter?
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "dd-MM-yyyy"
        }
        return dateFormatter!
    }
    
    func haveEvent(forDay date: Date) -> Bool {
        for event: GTLCalendarEvent! in events {
            if (event == nil) {
                break
            }
        
            let date_string = date.description as String!
            let event_string = event.created.date.description as String!
            
            let date_start = date_string?.index((date_string?.startIndex)!, offsetBy: 10)
            let event_start = event_string?.index((event_string?.startIndex)!, offsetBy: 10)
            
            let date_sub = date_string?.substring(to: date_start!)
            let event_sub = event_string?.substring(to: event_start!)
            
            if date_sub == event_sub {
                return true;
            }
        }
        return false;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
