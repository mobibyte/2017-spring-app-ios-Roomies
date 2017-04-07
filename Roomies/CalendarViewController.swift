//
//  CalendarViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 4/7/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import JTCalendar

class CalendarViewController: UIViewController, JTCalendarDelegate {

    @IBOutlet weak var calendarView: JTVerticalCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = JTCalendarManager()
        calendar.delegate = self
        
        
        calendarView.manager = calendar
        
        calendar.contentView = calendarView
        calendar.setDate(Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
