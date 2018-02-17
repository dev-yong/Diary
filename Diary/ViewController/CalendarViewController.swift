//
//  CalendarViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: ViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    let formatter = DateFormatter()
    var prePostVisibility: ((CellState, CalendarCell?)->())?
    var todayComponents: DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar.dateComponents([.year, .month, .day], from: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        print(Date().description(with: Locale.current))
    }
    override func setViewController() {
        
    }
    
    func setUpCalendarView() {
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.showsVerticalScrollIndicator = false
        self.calendarView.isPagingEnabled = true
        self.calendarView.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.calendarView.ibCalendarDelegate = self
        self.calendarView.ibCalendarDataSource = self
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.prePostVisibility = {state, cell in
            if state.dateBelongsTo == .thisMonth {
                cell?.isHidden = false
            } else {
                cell?.isHidden = true
            }
        }
        
        self.calendarView.visibleDates { (visibleDates) in
            self.getCalendarVisibleDates(from: visibleDates)
        }
        self.calendarView.reloadData()
        self.calendarView.scrollToDate(Date())
    }
    
    func getCalendarVisibleDates(from visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            self.formatter.dateFormat = "yyyy년"
            self.yearLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "M월"
            self.monthLabel.text = self.formatter.string(from: date)
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        self.prePostVisibility?(cellState, cell as? CalendarCell)
    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState){
        guard let cell = cell as? CalendarCell else {return }
        cell.selectedView.isHidden = !(cell.isSelected)
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        guard let cell = cell as? CalendarCell else {return }
        switch cellState.dateBelongsTo {
        case .thisMonth:
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone =  Calendar.current.timeZone
            formatter.locale = Calendar.current.locale
            cell.isUserInteractionEnabled = false
            let today = formatter.date(from: "\(todayComponents.year!) \(todayComponents.month!) \(todayComponents.day!)")!
            if cellState.date < today {
                cell.dateLabel.textColor = UIColor.lightGray
                
            }
            else if cellState.date == today {
                cell.dateLabel.textColor = UIColor.blue
            }
            else {
                cell.dateLabel.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
            }
        default :
            break
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCellConfiguration(cell: cell, cellState: cellState)
        return cell
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone =  Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let start = formatter.date(from: "\(todayComponents.year!) 01 01")
        let end = formatter.date(from: "\(todayComponents.year! + 5) 12 31")
        return ConfigurationParameters(startDate: start!, endDate: end!, generateOutDates: .tillEndOfRow)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
        print(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.getCalendarVisibleDates(from: visibleDates)
    }
}