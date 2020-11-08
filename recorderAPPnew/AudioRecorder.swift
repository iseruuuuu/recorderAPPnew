


import Foundation
import SwiftUI
import Combine
import AVFoundation
import AVKit

class AudioRecorder: NSObject,ObservableObject {
    override init() {
        super.init()
        fetchRecordings()
   
    }
    /*
    final class AudioManager{
        var audioRecorder: AVAudioRecorder!
        var audioEngine: AVAudioEngine!
        var audioFile : AVAudioFile!
        var audioPlayerNode: AVAudioPlayerNode!
        var audi0UnitTimePitch: AVAudioUnitTimePitch!
        
        init(){}
        
    }
    
 */
    
    
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print ("Faild to set up recording session")
        }
        
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //ファイル名の設定
        // let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "「YYYY-MM-dd HH:mm:ss」")).m4a")
        
        
        
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
        
    }
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        fetchRecordings()
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        objectWillChange.send(self)
    }
    
    func getAudioFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("record.m4a")
        return audioUrl
        
    }
    
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        fetchRecordings()
    }
}




