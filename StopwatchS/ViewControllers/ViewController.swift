//
//  ViewController.swift
//  StopwatchS
//
//  Created by leslie on 11/16/19.
//  Copyright © 2019 leslie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    
    var timer = Timer()
    
    var targetTime: Int {
        get {
            return UserDefaults.standard.integer(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
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
        
    }
    
    func pauseRun() {
        startBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func continueRun() {
        startBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    func reset() {
        stopWatchIsOn = false
        totalTime = 0
        targetTime = -1
        timer.invalidate()
    }
    
    @objc func change() {
        if targetTime == -1 {
            let displayTime = Date().timeIntervalSince(startTime) + totalTime
            covertTimeInterval(interval: TimeInterval(displayTime))
            
            print(">> TimeVC.change.displayTime: \(displayTime)")
        } else {
            let intervalTime = startTime.timeIntervalSinceNow
            let displayTime = Int(intervalTime) + targetTime
            covertTimeInterval(interval: TimeInterval(displayTime))
            print(">> TimeVC.change.intervalTime(startTime.timeIntervalSinceNow): \(intervalTime)")
            print(">> TimeVC.change.displayTime(intervalTime + targetTime): \(displayTime)")
        }
    }
    
    func covertTimeInterval(interval: TimeInterval) {

        let absInterval = abs(Int(interval))
        let seconds = absInterval % 60
        let minutes = (absInterval / 60) % 60
        let hours = (absInterval / 3600)
        
        if targetTime == -1 {
            let msec = interval.truncatingRemainder(dividingBy: 1)
            
            displayLbl.text = hours == 0 ? String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100)) : String(hours) + ":" + String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100))
        }
        
        if hours != 0 {
            displayLbl.text = String(hours) + ":" + String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds)
        } else if minutes != 0 {
            displayLbl.text = String(minutes) + ":" + String(format: "%.2d", seconds)
        } else {
            displayLbl.text = String(seconds)
        }
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        //reset timer when user press this button when timer is running
        if targetTime != -1 {
            reset()
        }
        targetTime = -1
        timer.invalidate()
        pauseRun()
        if !stopWatchIsOn {
            stopWatchIsOn = true
            startTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(change), userInfo: nil, repeats: true)
            pauseRun()
        } else {
            stopWatchIsOn = false
            continueRun()
            totalTime += Date().timeIntervalSince(startTime)
        }
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        reset()
        startBtn.setImage(UIImage(named: "startRunningButton"), for: .normal)
    }
}

