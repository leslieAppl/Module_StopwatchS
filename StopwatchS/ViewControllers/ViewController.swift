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
        displayLbl.addGestureRecognizer(tapToResetGesture)
        displayLbl.isUserInteractionEnabled = true
        tapToResetGesture.delegate = self as UIGestureRecognizerDelegate
        
        restoreStatus()
    }
    
    func restoreStatus() {
        
        if stopWatchIsOn {
            // run Timer forever mode.
            // even if shutdown the app, it will still keep counting from last time whenever open it again!!
            stopWatchIsOn = true
            
            //if keep the code "startTime = Date()" here, app will always start from "0".
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(change), userInfo: nil, repeats: true)
            
            toPause()
        } else {
            if totalTime == 0.0 {
                // reset mode.
                // perfectly stopped timer then shutdown the app.
            } else if totalTime > 0.0 {
                // before shutdown the app the startBtn is on 'toResume' mode.
                // press the toResume button to continue accounting time after restarting the app.
                toResume()
                let displayTime = totalTime
                covertTimeInterval(interval: TimeInterval(displayTime))
                stopWatchIsOn = false
            }
            
        }
    }
        
    func toPause() {
        startBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func toResume() {
        startBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    func reset() {
        stopWatchIsOn = false
        totalTime = 0
        timer.invalidate()
    }
    
    @objc func change() {
        let displayTime = Date().timeIntervalSince(startTime) + totalTime
        covertTimeInterval(interval: TimeInterval(displayTime))
    }
    
    func covertTimeInterval(interval: TimeInterval) {

        let absInterval = abs(Int(interval))
        let seconds = absInterval % 60
        let minutes = (absInterval / 60) % 60
        let hours = (absInterval / 3600)
        let msec = interval.truncatingRemainder(dividingBy: 1)
        
        displayLbl.text = hours == 0 ? String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100)) : String(hours) + ":" + String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100))
        
        if hours != 0 {
            displayLbl.text = String(hours) + ":" + String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds)
        } else if minutes != 0 {
            displayLbl.text = String(minutes) + ":" + String(format: "%.2d", seconds)
        } else {
            displayLbl.text = String(seconds)
        }
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        timer.invalidate()
        toPause()
        
        if !stopWatchIsOn {
            stopWatchIsOn = true
            startTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(change), userInfo: nil, repeats: true)
            
            toPause()
        } else {
            stopWatchIsOn = false
            totalTime += Date().timeIntervalSince(startTime)
            
            toResume()
        }
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        reset()
        startBtn.setImage(UIImage(named: "startRunningButton"), for: .normal)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func resetTime(sender: UITapGestureRecognizer) {
        reset()
        displayLbl.text = "0"
        startBtn.setImage(UIImage(named: "startRunningButton"), for: .normal)
    }
}

