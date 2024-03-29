//
//  ViewController.swift
//  StopwatchS
//
//  Created by leslie on 11/16/19.
//  Copyright © 2019 leslie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var disLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    
    var timer = Timer()
    
    var stopWatchIsOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var startTime: Date {
        get {
            if let time = UserDefaults.standard.object(forKey: #function) as? Date { return time }
            return Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var totalTime: Double {
        get {
            return UserDefaults.standard.double(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add gesture to displayLbl
        let tapToResetGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resetTime))
        disLbl.addGestureRecognizer(tapToResetGesture)
        disLbl.isUserInteractionEnabled = true
        tapToResetGesture.delegate = self as UIGestureRecognizerDelegate

        restoreStatus()
    }
    
    func restoreStatus() {
        
        if stopWatchIsOn {
            // continue Timer mode
            // continue Timer tick-tock
            
            // remove 'Reset Timer to 00:00 function' below
            // Change current time value to 'startTime' variable at plist.
            // startTime = Date()
            
            // setting (sending message to) Timer tick-tock interval value to the Timer instance.
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(toStart), userInfo: nil, repeats: true)
            
            stopWatchIsOn = true
            print(">>> stopWatchIsOn: \(stopWatchIsOn)")
            toPause()
        } else {
            if totalTime == 0.0 {
                // reset Timer mode.
                // ready to restart from 00:00
            } else if totalTime > 0.0 {
                // Paused Timer mode
                // ready to Resume Timer
                toResume()
                
                let displayTime = totalTime
                covertTimeInterval(interval: TimeInterval(displayTime))
                
                stopWatchIsOn = false
                print(">>> stopWatchIsOn: \(stopWatchIsOn)")
            }
            
        }
    }
        
    func toPause() {
        startBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func toResume() {
        startBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    func toReset() {
        timer.invalidate()
        totalTime = 0
        print(">>> saving totalTime: \(totalTime)")
        
        stopWatchIsOn = false
            print(">>> stopWatchIsOn: \(stopWatchIsOn)")
    }
    
    @objc func toStart() {
        // dot-notation to call 'timeIntervalSince()' function sending message 'displayTime' variable.
        // timeIntervalSince's parameter: fetch saved 'startTime' value from plist.
        let displayTime = Date().timeIntervalSince(startTime) + totalTime
            print("> displayTime: \(displayTime)")
        covertTimeInterval(interval: TimeInterval(displayTime))
    }
    
    // parameter (interval: TimeInterval): A TimeInterval value is always specified in seconds.
    func covertTimeInterval(interval: TimeInterval) {

        let absInterval = abs(Int(interval))
            print(">> absInterval: \(absInterval)")
        let seconds = absInterval % 60
            print(">> seconds: \(seconds)")
        let minutes = (absInterval / 60) % 60
            print(">> minutes: \(minutes)")
        // the hours doesn't need to use remainder, cause the hour can bigger than 60.
        let hours = (absInterval / 3600)
            print(">> hours: \(hours)")
        let msec = interval.truncatingRemainder(dividingBy: 1)
            print(">> msec: \(msec)")
        
        // displayLbl.text =  [ hours == 0 ]  ?  [ String(format: 1 ) ]  :  [ String(format: 2 ) ]
        // 'hours == 0' is a condition.
        // if it's true, assign the String(format:) after the '?' mark into displayLbl.text.
        // if it's false, assign the String(format:) after the ':' mark into displayLbl.text.
        disLbl.text = hours == 0
            ? String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100))
            : String(hours) + ":" + String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100))
        
        // require fixed distances between digits.
        disLbl.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .regular)
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        // stop Timer tick-tock
        timer.invalidate()
        toPause()
        
        if !stopWatchIsOn {
            // To Start Timer
            
            // Reset Timer to 00:00
            // Change current time value to 'startTime' variable at plist.
            startTime = Date()
            print(">>> saving startTime: Date \(startTime)")
            
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(toStart), userInfo: nil, repeats: true)
            
            stopWatchIsOn = true
            print(">>> stopWatchIsOn: \(stopWatchIsOn)")
            toPause()
        } else {
            // To Pause Timer
            // adding 'time interval since startTime' onto the 'totalTime' variable.
            totalTime += Date().timeIntervalSince(startTime)
            print(">>> saving totalTime: \(totalTime)")
            
            toResume()
            stopWatchIsOn = false
            print(">>> stopWatchIsOn: \(stopWatchIsOn)")
        }
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        toReset()
        startBtn.setImage(UIImage(named: "startRunningButton"), for: .normal)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func resetTime(sender: UITapGestureRecognizer) {
        toReset()
        disLbl.text = "00:00.00"
        startBtn.setImage(UIImage(named: "startRunningButton"), for: .normal)
    }
}

