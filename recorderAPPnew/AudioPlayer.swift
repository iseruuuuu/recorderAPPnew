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
        } catch {
            print("Playing over the device's speaker failled")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func stopPlayBack() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
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
     
     */
}
