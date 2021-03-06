//
//  EleventhViewController.swift
//  WorkoutTimer
//
//  Created by Santos, Russell on 7/17/17.
//  Copyright © 2017 theswiftproject. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class EleventhViewController: UIViewController {
    
    var blastOffHasOccured = false
    var countDownNum = 10
    
    var fullCounter = Timer()
    var countDown = Timer()
    var timer = Timer()
    var coolDownTimer = Timer()
    
    var melody = AVAudioPlayer()
    var audioPlayer = AVAudioPlayer()
    var blastOff = AVAudioPlayer()
    var coolDownMelody = AVAudioPlayer()
    var completedMelody = AVAudioPlayer()
    
    var coolDownMelodyPlayed = false
    var buglePlayed = false
    var doingWarmUp = true
    var doingCoolDown = true
    var resumingRun = false
    var melodyPlayed = false
    var workoutInProgress = false
    
    var inCountDown = false
    var inPause = false
    
    var running = true
    var paused = false
    
    var beginWorkoutIn = false
    var beginWarmUpIn = false
    var beginCoolDownIn = false
    var runEndsIn = false
    
    
    
    var usersName = String()
    var warmUpSeconds = Int()
    var warmUpMinutes = Int()
    var warmUpHours = Int()
    var coolDownSeconds = Int()
    var coolDownMinutes = Int()
    var coolDownHours = Int()
    var fullRunSeconds = Int()
    var fullRunMinutes = Int()
    var fullRunHours = Int()
    
    
    
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var time: UILabel!
  
    
    //when End button is clicked go back to the edit page
    @IBAction func endRun(_ sender: UIButton) {
        
        //also tell user that the workout is ending
        let utterance = AVSpeechUtterance(string: "Ending run. Nice job")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        if melody.isPlaying {
            melody.stop()
        }
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        if blastOff.isPlaying {
           blastOff.stop()
        }
        if coolDownMelody.isPlaying {
           coolDownMelody.stop()
        }
        
        /* 
         *Ensures that the all of the timers
         *stop when the run ends
         */
        fullCounter.invalidate()
        countDown.invalidate()
        timer.invalidate()
        coolDownTimer.invalidate()
        
    }
    
    
    
    //once the user clicks the Begin Countdown/Resume button
    @IBAction func startTimer(_ sender: UIButton) {
        
        if (!inCountDown) {
            inPause = false
            //if the user is doing a warmup and the countdown has not happened yet
            if (!blastOffHasOccured) {
                inCountDown = true
                //use the countdown timer
                countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.countDownTimer), userInfo: nil, repeats: true)
            }
            
                
                //if the user is hitting the now Resume button and therefore
                //the countdown has already happened, resume the warmup timer
            else {
                //use the running boolean because if the user
                //continuously clicks resume when the timer is not paused
                //the time decrements at a faster pace than 1 second
                if (resumingRun) && (!running){
                    
                    running = true
                    paused = false
                    
                    if doingWarmUp {
                        
                        let utterance = AVSpeechUtterance(string: "Resuming warm up")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                        utterance.rate = 0.5
                        
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                        beginWarmUp()
                        
                    } else if workoutInProgress {
                        
                        let utterance = AVSpeechUtterance(string: "Resuming workout")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                        utterance.rate = 0.5
                        
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                        beginWorkout()
                        
                    } else if ((doingCoolDown) && (!workoutInProgress) && (!doingWarmUp)) {
                        
                        let utterance = AVSpeechUtterance(string: "Resuming cool down")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                        utterance.rate = 0.5
                        
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                        beginCoolDown()
                    }
                    
                } else {
                    
                    let utterance = AVSpeechUtterance(string: "The timers already running!")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
            }
        }
    }
    
    func beginWarmUp() {
   
        resumeButton.setTitle("Resume", for: .normal)
        //creates the timer object that is connected to the counter function
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.counter), userInfo: nil, repeats: true)
        
        //if the bugle sound hasn't been played (the bugle flag is false)
        if !melodyPlayed {
            //then play the bugle
            melody.play()
            //and set the bugle flag to true
            melodyPlayed = true
            
            //inform the user that workout has began (begun?)
            let utterance = AVSpeechUtterance(string: "Begin warm up! Make sure to take it easy " + usersName + "!")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        
        if (!inCountDown) {
            running = false
            paused = true
            
            if doingWarmUp {
                
                if (inPause) {
                    
                    let utterance = AVSpeechUtterance(string: "Warm up is already paused!")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                    
                } else {
                    
                    let utterance = AVSpeechUtterance(string: "Pausing warm up")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
                
                
            } else if workoutInProgress {
                
                if (inPause){
                    let utterance = AVSpeechUtterance(string: "Workout is already paused!")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                    
                } else {
                    
                    let utterance = AVSpeechUtterance(string: "Pausing workout")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
                
                
                
                
            } else if ((doingCoolDown) && (!workoutInProgress) && (!doingWarmUp)) {
                
                if (inPause) {
                    
                    let utterance = AVSpeechUtterance(string: "Cool down is already paused")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                    
                } else {
                    
                    let utterance = AVSpeechUtterance(string: "Pausing cool down")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
               
            }
            
            
            resumingRun = true
            inPause = true
            timer.invalidate()
            fullCounter.invalidate()
            coolDownTimer.invalidate()

        }
    }
   
   
    func countDownTimer () {
        //countdown for the warmup
        if doingWarmUp {
            //adjust the font
            time.font = time.font.withSize(30)
            
            if (!beginWarmUpIn){
                
                let utterance = AVSpeechUtterance(string: "Begin warm up in!")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                
                beginWarmUpIn = true
            }
            
            //play the countdown soundtrack
            blastOff.play()
            //this is the countdown that shows on the label
            if countDownNum > -2 {
                if countDownNum == 10 {
                    inCountDown = true
                    //set the label, if it's 10 don't put the zero
                    //in front, else put it in front
                    time.text = "Begin Warmup In: \n" + String(countDownNum)
                } else {
                    time.text = "Begin Warmup In: \n" + "0" + String(countDownNum)
                }
                //decrement the time counter
                countDownNum -= 1
            }
            //once the countdown is over
            if countDownNum == -2 {
                inCountDown = false
                //ensure that 0 appears on the screen briefly
                time.text = "Begin Warmup In: \n" + "00"
                time.font = time.font.withSize(30)
                time.text = "Begin Warmup"
                //stop the countdown timer
                countDown.invalidate()
                //set the countdown flag to true so it isn't played again
                //once the button turns to resume
                blastOffHasOccured = true
                //begin the warmup (eventually workout option as well)
                beginWarmUp()
            }
            
            
            //countdown for the workout (for now until cooldown implemented might change then)
        } else if (!doingWarmUp) && (workoutInProgress) {
            //adjust the font
            time.font = time.font.withSize(30)
            
            if (!beginWorkoutIn) {
                
                let utterance = AVSpeechUtterance(string: "Begin workout in!")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                
                beginWorkoutIn = true
            }
            
            //play the countdown soundtrack
            blastOff.play()
            //this is the countdown that shows on the label
            if countDownNum > -2 {
                if countDownNum == 10 {
                    inCountDown = true
                    //set the label, if it's 10 don't put the zero
                    //in front, else put it in front
                    time.text = "Begin Workout In: \n" + String(countDownNum)
                } else {
                    time.text = "Begin Workout In: \n" + "0" + String(countDownNum)
                }
                //decrement the time counter
                countDownNum -= 1
            }
            //once the countdown is over
            if countDownNum == -2 {
                inCountDown = false
                //ensure that 0 appears on the screen briefly
                time.text = "Begin Workout In: \n" + "00"
                time.font = time.font.withSize(30)
                time.text = "Begin Workout"
                //stop the countdown timer
                countDown.invalidate()
                //set the countdown flag to true so it isn't played again
                //once the button turns to resume
                blastOffHasOccured = true
                //begin the warmup (eventually workout option as well)
                beginWorkout()
            }
            
            
        } else if ((!workoutInProgress) && (doingCoolDown) && (!doingWarmUp)) {
            //adjust the font
            time.font = time.font.withSize(30)
            
            if (!beginCoolDownIn) {
                
                let utterance = AVSpeechUtterance(string: "Begin cool down in!")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                
                beginCoolDownIn = true
            }
            
            //play the countdown soundtrack
            blastOff.play()
            //this is the countdown that shows on the label
            if countDownNum > -2 {
                if countDownNum == 10 {
                    inCountDown = true
                    //set the label, if it's 10 don't put the zero
                    //in front, else put it in front
                    time.text = "Begin Cooldown In: \n" + String(countDownNum)
                } else {
                    time.text = "Begin Cooldown In: \n" + "0" + String(countDownNum)
                }
                //decrement the time counter
                countDownNum -= 1
            }
            //once the countdown is over
            if countDownNum == -2 {
                inCountDown = false
                //ensure that 0 appears on the screen briefly
                time.text = "Begin Cooldown In: \n" + "00"
                time.font = time.font.withSize(30)
                time.text = "Begin Cooldown"
                //stop the countdown timer
                countDown.invalidate()
                //set the countdown flag to true so it isn't played again
                //once the button turns to resume
                blastOffHasOccured = true
                //begin the warmup (eventually workout option as well)
                beginCoolDown()
            }

            //no cooldown and workout is over
        } else {
            
            //adjust the font
            time.font = time.font.withSize(30)
            
            if (!runEndsIn){
                
                let utterance = AVSpeechUtterance(string: "End run in!")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                
                runEndsIn = true
            }
            
            //play the countdown soundtrack
            blastOff.play()
            //this is the countdown that shows on the label
            if countDownNum > -2 {
                if countDownNum == 10 {
                    //set the label, if it's 10 don't put the zero
                    //in front, else put it in front
                    time.text = "Run Ends In: \n" + String(countDownNum)
                } else {
                    time.text = "Run Ends In: \n" + "0" + String(countDownNum)
                }
                //decrement the time counter
                countDownNum -= 1
            }
            //once the countdown is over
            if countDownNum == -2 {
                inCountDown = false
                //ensure that 0 appears on the screen briefly
                time.text = "Run Ends In: \n" + "00"
                time.font = time.font.withSize(30)
                time.text = "Run Completed!"
                //stop the countdown timer
                countDown.invalidate()
                //set the countdown flag to true so it isn't played again
                //once the button turns to resume
                blastOffHasOccured = true
                
                //also tell user that the workout is ending
                let utterance = AVSpeechUtterance(string: "Run completed! Awesome work " + usersName + "!")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                
                completedMelody.play()
                
                if melody.isPlaying {
                    melody.stop()
                }
                if audioPlayer.isPlaying {
                    audioPlayer.stop()
                }
                if blastOff.isPlaying {
                    blastOff.stop()
                }
                if coolDownMelody.isPlaying {
                    coolDownMelody.stop()
                }
                
                fullCounter.invalidate()
                countDown.invalidate()
                timer.invalidate()
                coolDownTimer.invalidate()
                
                performSegue(withIdentifier: "endWorkout", sender: nil)
            }
        }
    }
    
    
    func alternateCountDownTimer() {
        //countdown for the warmup
        if doingWarmUp {
            //adjust the font
            time.font = time.font.withSize(30)
             time.text = "Begin Warmup"
            beginWarmUp()
            
            
            //countdown for the workout (for now until cooldown implemented might change then)
        } else if (!doingWarmUp) && (workoutInProgress) {
            //adjust the font
            time.font = time.font.withSize(30)
            //begin the warmup (eventually workout option as well)
            time.text = "Begin Workout"
            beginWorkout()
            
            
            
        } else if ((!workoutInProgress) && (doingCoolDown) && (!doingWarmUp)) {
            //adjust the font
            time.font = time.font.withSize(30)
            //begin the warmup (eventually workout option as well)
            time.text = "Begin Cooldown"
            beginCoolDown()
 
            
            //no cooldown and workout is over
        } else {
            
            //adjust the font
            time.font = time.font.withSize(30)
            //play the countdown soundtrack
            
            time.text = "Run Completed!"
            //stop the countdown timer

            //set the countdown flag to true so it isn't played again
            //once the button turns to resume
            blastOffHasOccured = true
                
            //also tell user that the workout is ending
            let utterance = AVSpeechUtterance(string: "Run completed! Awesome work " + usersName + "!")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
                
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            
            completedMelody.play()
                
            if melody.isPlaying {
                melody.stop()
            }
            if audioPlayer.isPlaying {
                audioPlayer.stop()
            }
            if blastOff.isPlaying {
                blastOff.stop()
            }
            if coolDownMelody.isPlaying {
                coolDownMelody.stop()
            }
                
            fullCounter.invalidate()
            countDown.invalidate()
            timer.invalidate()
            coolDownTimer.invalidate()
                
            performSegue(withIdentifier: "endWorkout", sender: nil)
        }
    }
    
    
    func counter () {
        //set the the font to be larger when the timer is running
        time.font = time.font.withSize(60)
        
        //add on to this String for time
        var timerText = ""
        
        //if there is warmup hours then add it and an extra zero for appearance to the String
        //followed by a colon
        if warmUpHours > 0 {
            timerText = "0" + String(warmUpHours) + ":"
        }
        
        //if warmup minutes exist and are less than 10
        if (warmUpMinutes > 0) && (warmUpMinutes < 10) {
            //add a zero in front for appearance and a colon at the end
            timerText = timerText + "0" + String(warmUpMinutes) + ":"
            
            //if warmup minutes is greater than or equal to 10
        } else if (warmUpMinutes >= 10) {
            //add it to the String without the extra zero, putting a colon at the end
            timerText = timerText + String(warmUpMinutes) + ":"
            
            //if warmup minutes are zero, but didn't just hit zero
            //as seconds are not zero, and hours are greater than 0
        } else if (warmUpMinutes == 0) && (warmUpHours != 0) && (warmUpSeconds != 0){
            //add two zeros to the String followed by a colon
            timerText = timerText + "00" + ":"
        }
        
        //if seconds are between 0 and 10
        if (warmUpSeconds > 0) && (warmUpSeconds < 10) {
            //add a zero in front for appearance
            timerText = timerText + "0" + String(warmUpSeconds)
            
            //if seconds are greater than or equal to 10
        } else if (warmUpSeconds >= 10) {
            //add it to the String
            timerText = timerText + String(warmUpSeconds)
        }
        
        //if seconds just hit 0 and there are more minutes remaining
        if (warmUpSeconds == 0) && (warmUpMinutes > 0) {
            //put a zero in front the zero that will be seconds
            timerText = timerText + "0" + String(warmUpSeconds)
            //subtract 1 from minutes
            warmUpMinutes -= 1
            //set seconds to 60, although it will display 00 at the time and then fall to 59
            warmUpSeconds = 60
            
            //if seconds just hit 0 and minutes just hit 0, but there are more hours
        } else if (warmUpSeconds == 0) && (warmUpMinutes == 0) && (warmUpHours > 0){
            //put zeros in front of the seconds and minutes
            timerText = timerText + "0" + String(warmUpMinutes) + ":"
            timerText = timerText + "0" + String(warmUpSeconds)
            //subtract 1 from the hours
            warmUpHours -= 1
            //set the seconds to 60, although it will display 00 at the time and then fall to 59
            warmUpSeconds = 60
            //set minutes to 59, although it will display 00 at the time
            //this is ok since it's only seconds that are decremented
            warmUpMinutes = 59
        }
        
        //set label to the String with the hours, minutes, and seconds value displayed
        time.text = timerText
        
        //once the time gets down to 10
        if (warmUpSeconds == 11) && (warmUpMinutes == 0) && (warmUpHours == 0){
            countDownNum = 10
            timer.invalidate()
            doingWarmUp = false
            workoutInProgress = true
            melodyPlayed = false
            countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.countDownTimer), userInfo: nil, repeats: true)
        } else if (warmUpSeconds == 0) && (warmUpMinutes == 0) && (warmUpHours == 0) {
            timer.invalidate()
            doingWarmUp = false
            workoutInProgress = true
            melodyPlayed = false
            alternateCountDownTimer()
        }
        
        
        //decrement the seconds
        warmUpSeconds -= 1
        
    }
    
    func beginWorkout() {
    
        resumeButton.setTitle("Resume", for: .normal)
        //creates the timer object that is connected to the counter function
        fullCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.workoutCounter), userInfo: nil, repeats: true)
        
        //if the bugle sound hasn't been played (the bugle flag is false)
        if !buglePlayed {
            //then play the bugle
            audioPlayer.play()
            //and set the bugle flag to true
            buglePlayed = true
            
            //inform the user that workout has began (begun?)
            let utterance = AVSpeechUtterance(string: "Begin workout! Good luck " + usersName + "!")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
    }
    
    func beginCoolDown() {
    
        resumeButton.setTitle("Resume", for: .normal)
        //creates the timer object that is connected to the counter function
        coolDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.coolDownCounter), userInfo: nil, repeats: true)
        
        //if the bugle sound hasn't been played (the bugle flag is false)
        if !coolDownMelodyPlayed{
            //then play the bugle
            coolDownMelody.play()
            //and set the bugle flag to true
            coolDownMelodyPlayed = true
            
            //inform the user that workout has began (begun?)
            let utterance = AVSpeechUtterance(string: "Begin cool down! Time to chill!")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
    }
    
    
    func coolDownCounter() {
        
        //set the the font to be larger when the timer is running
        time.font = time.font.withSize(60)
        
        //add on to this String for time
        var timerText = ""
        
        //if there is warmup hours then add it and an extra zero for appearance to the String
        //followed by a colon
        if coolDownHours > 0 {
            timerText = "0" + String(coolDownHours) + ":"
        }
        
        //if warmup minutes exist and are less than 10
        if (coolDownMinutes > 0) && (coolDownMinutes < 10) {
            //add a zero in front for appearance and a colon at the end
            timerText = timerText + "0" + String(coolDownMinutes) + ":"
            
            //if warmup minutes is greater than or equal to 10
        } else if (coolDownMinutes >= 10) {
            //add it to the String without the extra zero, putting a colon at the end
            timerText = timerText + String(coolDownMinutes) + ":"
            
            //if warmup minutes are zero, but didn't just hit zero
            //as seconds are not zero, and hours are greater than 0
        } else if (coolDownMinutes == 0) && (coolDownHours != 0) && (coolDownSeconds != 0){
            //add two zeros to the String followed by a colon
            timerText = timerText + "00" + ":"
        }
        
        //if seconds are between 0 and 10
        if (coolDownSeconds > 0) && (coolDownSeconds < 10) {
            //add a zero in front for appearance
            timerText = timerText + "0" + String(coolDownSeconds)
            
            //if seconds are greater than or equal to 10
        } else if (coolDownSeconds >= 10) {
            //add it to the String
            timerText = timerText + String(coolDownSeconds)
        }
        
        //if seconds just hit 0 and there are more minutes remaining
        if (coolDownSeconds == 0) && (coolDownMinutes > 0) {
            //put a zero in front the zero that will be seconds
            timerText = timerText + "0" + String(coolDownSeconds)
            //subtract 1 from minutes
            coolDownMinutes -= 1
            //set seconds to 60, although it will display 00 at the time and then fall to 59
            coolDownSeconds = 60
            
            //if seconds just hit 0 and minutes just hit 0, but there are more hours
        } else if (coolDownSeconds == 0) && (coolDownMinutes == 0) && (coolDownHours > 0){
            //put zeros in front of the seconds and minutes
            timerText = timerText + "0" + String(coolDownMinutes) + ":"
            timerText = timerText + "0" + String(coolDownSeconds)
            //subtract 1 from the hours
            coolDownHours -= 1
            //set the seconds to 60, although it will display 00 at the time and then fall to 59
            coolDownSeconds = 60
            //set minutes to 59, although it will display 00 at the time
            //this is ok since it's only seconds that are decremented
            coolDownMinutes = 59
        }
        
        //set label to the String with the hours, minutes, and seconds value displayed
        time.text = timerText
        
        //once the time runs out stop
        if (coolDownSeconds == 11) && (coolDownMinutes == 0) && (coolDownHours == 0){
            countDownNum = 10
            fullCounter.invalidate()
            workoutInProgress = false
            melodyPlayed = false
            doingCoolDown = false
            countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.countDownTimer), userInfo: nil, repeats: true)
        } else if (coolDownSeconds == 0) && (coolDownMinutes == 0) && (coolDownHours == 0) {
            fullCounter.invalidate()
            workoutInProgress = false
            melodyPlayed = false
            doingCoolDown = false
            alternateCountDownTimer()
        }
        
        //decrement the seconds
        coolDownSeconds -= 1
        
    }
    
    
    func workoutCounter () {
        //set the the font to be larger when the timer is running
        time.font = time.font.withSize(60)
        
        //add on to this String for time
        var timerText = ""
        
        //if there is warmup hours then add it and an extra zero for appearance to the String
        //followed by a colon
        if fullRunHours > 0 {
            timerText = "0" + String(fullRunHours) + ":"
        }
        
        //if warmup minutes exist and are less than 10
        if (fullRunMinutes > 0) && (fullRunMinutes < 10) {
            //add a zero in front for appearance and a colon at the end
            timerText = timerText + "0" + String(fullRunMinutes) + ":"
            
            //if warmup minutes is greater than or equal to 10
        } else if (fullRunMinutes >= 10) {
            //add it to the String without the extra zero, putting a colon at the end
            timerText = timerText + String(fullRunMinutes) + ":"
            
            //if warmup minutes are zero, but didn't just hit zero
            //as seconds are not zero, and hours are greater than 0
        } else if (fullRunMinutes == 0) && (fullRunHours != 0) && (fullRunSeconds != 0){
            //add two zeros to the String followed by a colon
            timerText = timerText + "00" + ":"
        }
        
        //if seconds are between 0 and 10
        if (fullRunSeconds > 0) && (fullRunSeconds < 10) {
            //add a zero in front for appearance
            timerText = timerText + "0" + String(fullRunSeconds)
            
            //if seconds are greater than or equal to 10
        } else if (fullRunSeconds >= 10) {
            //add it to the String
            timerText = timerText + String(fullRunSeconds)
        }
        
        //if seconds just hit 0 and there are more minutes remaining
        if (fullRunSeconds == 0) && (fullRunMinutes > 0) {
            //put a zero in front the zero that will be seconds
            timerText = timerText + "0" + String(fullRunSeconds)
            //subtract 1 from minutes
            fullRunMinutes -= 1
            //set seconds to 60, although it will display 00 at the time and then fall to 59
            fullRunSeconds = 60
            
            //if seconds just hit 0 and minutes just hit 0, but there are more hours
        } else if (fullRunSeconds == 0) && (fullRunMinutes == 0) && (fullRunHours > 0){
            //put zeros in front of the seconds and minutes
            timerText = timerText + "0" + String(fullRunMinutes) + ":"
            timerText = timerText + "0" + String(fullRunSeconds)
            //subtract 1 from the hours
            fullRunHours -= 1
            //set the seconds to 60, although it will display 00 at the time and then fall to 59
            fullRunSeconds = 60
            //set minutes to 59, although it will display 00 at the time
            //this is ok since it's only seconds that are decremented
            fullRunMinutes = 59
        }
        
        //set label to the String with the hours, minutes, and seconds value displayed
        time.text = timerText
        
        //once the time runs out stop
        if (fullRunSeconds == 11) && (fullRunMinutes == 0) && (fullRunHours == 0){
            countDownNum = 10
            fullCounter.invalidate()
            workoutInProgress = false
            melodyPlayed = false
            countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EleventhViewController.countDownTimer), userInfo: nil, repeats: true)
        } else if (fullRunSeconds == 0) && (fullRunMinutes == 0) && (fullRunHours == 0) {
            fullCounter.invalidate()
            workoutInProgress = false
            melodyPlayed = false
            alternateCountDownTimer()
        }
        
        //decrement the seconds
        fullRunSeconds -= 1
        
    }

    
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        whatEvents()
        
        time.font = time.font.withSize(30)
        
        if doingWarmUp {
            
            time.text = "Warmup Timer Ready"
        } else {
            time.text = "Workout Timer Ready"
        }
        
        do {
            //audio from www.audiomicro.com
            let audioPath = Bundle.main.path(forResource: "bugle", ofType: ".wav")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch {
            //ERROR
        }
        
        do {
            //audio from www.audiomicro.com
            let blastPath = Bundle.main.path(forResource: "countdown", ofType: ".wav")
            try blastOff = AVAudioPlayer(contentsOf: URL(fileURLWithPath: blastPath!))
        }
        catch {
            //ERROR
        }
        do {
            //audio from www.audiomicro.com
            let melodyPath = Bundle.main.path(forResource: "change-pace", ofType: ".wav")
            try melody = AVAudioPlayer(contentsOf: URL(fileURLWithPath: melodyPath!))
        }
        catch {
            //ERROR
        }
        do {
            //audio from www.audiomicro.com
            let coolDownPath = Bundle.main.path(forResource: "cool", ofType: ".wav")
            try coolDownMelody = AVAudioPlayer(contentsOf: URL(fileURLWithPath: coolDownPath!))
        }
        catch {
            //ERROR
        }
        do {
            //audio from www.audiomicro.com
            let completedPath = Bundle.main.path(forResource: "completed", ofType: ".wav")
            try completedMelody = AVAudioPlayer(contentsOf: URL(fileURLWithPath: completedPath!))
        }
        catch {
            //ERROR
        }
    }
    
    func whatEvents () {
        //if all warmup values equal zero then there is not a warmup
        if (warmUpSeconds == 0) && (warmUpMinutes == 0) && (warmUpHours == 0) {
            //set the warmup flag to false
            doingWarmUp = false
            workoutInProgress = true
        }
        
        //if all cooldown values equal zero then there is not a cooldown
        if (coolDownSeconds == 0) && (coolDownMinutes == 0) && (coolDownHours == 0) {
            
            //set the cooldown flag to false
            doingCoolDown = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //This segues back to the FifthViewController where the user decides what
    //type of run they want to do. Decided that's the best point in the app to 
    //send them to because they are still able to edit everything from that point on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endWorkout" {
                let destination : FifthViewController = segue.destination as! FifthViewController
                NSLog("End Workout")
                destination.usersName = String(usersName)
                destination.warmUpSeconds = warmUpSeconds
                destination.warmUpMinutes = warmUpMinutes
                destination.warmUpHours = warmUpHours
                destination.coolDownSeconds = coolDownSeconds
                destination.coolDownMinutes = coolDownMinutes
                destination.coolDownHours = coolDownHours
        }
    }
}

