//
//  AudioPlayer.swift
//  recorderAPPnew
//
//  Created by user on 2020/10/12.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
   // var audioPlayer = AVAudioPlayer()
    @State var sliderValue = 0.0
    var maxSlider = 60.0
    var minSlider = 0.0
  
   // @StateObject var sliderValue: RecordingList!//(audioPlayer: audioPlayer)
    //@StateObject var homeData : HomeViewModel!//(audioPlayer: audioPlayer)
    /*
     //追加した物
     var asset: AVAsset!
     var playerItem: AVPlayerItem!
     var timeObserverToken: Any?
     */
    
    
    
    func startPlayBack (audio: URL){
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
          //  try AVAudioSession.sharedInstance().setCategory(true)
        } catch {
            NSLog("audio session set category faikure")
            print("Playing over the device's speaker failled")
        }
        do {
           
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
  
    func pauseplay() {
        if audioPlayer.isPlaying == true {
            audioPlayer.stop()
            Image(systemName: "play.circle")
        }else {
            audioPlayer.play()
           // Image(systemName: "play.circle")
        }
    }
    
    
    func stopPlayBack() {
        audioPlayer.stop()
        isPlaying = false
      //  audioPlayer.pause()
      // isPlaying = false
    }
    
    
    func audiopause() {
        audioPlayer.pause()
    }
    
    
   
    

    func playprogress(){
        audioPlayer.currentTime +=  1
    }
 
  //  $sliderValue
    
    func playupdown() {
        if sliderValue <= 50 {
            audioPlayer.currentTime += 1
        }else {
            audioPlayer.currentTime -= 1
    }
    }
    
    func audioSlider2() {
        if minSlider < maxSlider {
            audioPlayer.currentTime += 1
        }else {
            audioPlayer.currentTime -= 1
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
  
    /*
     // %は使えなくなった。
     
     func currentTime() -> CMTime  {
     
     let rem = 2.5.truncatingRemainder(dividingBy: 1.1)
     
        audioPlayer.currentTime
     
     let time = audioPlayer.currentTime
     let minutes = Int(time / 60)
     let seconds = Int(time.truncatingRemainder(dividingBy: 60))
     currentTime.text = NSString(format:"%02d:%02d", minutes, seconds) as String
     }
     
     
}
*/
