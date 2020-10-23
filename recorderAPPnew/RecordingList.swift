




import SwiftUI
import Speech
import MediaPlayer
import AVKit
import AVFoundation
import Combine





struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State private var value: Double = 0
    
    
    
    
    
    
    
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
            }
            .onDelete(perform: delete)
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}


private func formatTime(sec: Int) -> String {
    let h = sec / 3600 % 24
    let m = sec / 60 % 60
    let s = sec % 60
    
    if h == 0 {
        return String(format: "%d:%02d", m, s)
    }
    else {
        return String(format: "%d:%d:%02d", h, m, s)
    }
}





struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    
    //  @State private var seekPosition: Double = 0.3
    
    @State private var  currentTime: Double = 0.3
    @State private var currentVolume: Double = 0.5
    
    private let secondaryGray: Color = .init(white: 0.75)
    
    var body: some View {
        // HStack(alignment:.center) {
        VStack(alignment:.center){
            
            
            Text("\(audioURL.lastPathComponent)")
                .font(.body)
            
            //private var seekBar: some View {
            
            VStack(spacing: 0) {
                Slider(value: $currentTime, in: 0...1)
                    .accentColor(secondaryGray)
                HStack {
                    //Text(formatTime(sec: Int(audioPlayer.audioPlayer.currentTime * currentTime)))
                    Text("00:00")
                        .font(.system(size: 14))
                        .foregroundColor(secondaryGray)
                    Spacer()
                    // Text("-" + formatTime(sec: Int(audioPlayer.audioPlayer.currentTime * (1 - currentTime))))
                    Text("01:00")
                        .font(.system(size: 14))
                        .foregroundColor(secondaryGray)
                }
            }
            //}
            
            //音量（多分使わない。）
            /*
             Slider(
             value: $currentVolume,
             in: 0...1,
             minimumValueLabel:
             Image(systemName: "speaker.fill")
             .font(.system(size: 10))
             .foregroundColor(secondaryGray),
             maximumValueLabel:
             Image(systemName: "speaker.3.fill")
             .font(.system(size: 10))
             .foregroundColor(secondaryGray)
             ) {}
             .accentColor(secondaryGray)
             
             */
            
            
            HStack(spacing: 60){
                
                //隙間を調整
                Button(action: {
                    print("")
                }) {
                    Text("")
                }
                
                
                //15秒戻る機能
                Button(action: {
                }) {
                    Image(systemName: "gobackward.15").onTapGesture {
                        audioPlayer.audioPlayer.currentTime -= 15
                    }
                    .imageScale(.medium)
                    .foregroundColor(.blue)
                    // システムアイコンを指定
                }
                .font(.title)
                //再生の処理
                if audioPlayer.isPlaying == false {
                    Button(action: {
                    }) {
                        Image(systemName: "play.circle").onTapGesture {
                            self.audioPlayer.startPlayBack(audio: self.audioURL)
                        }
                        .imageScale(.large)
                        .foregroundColor(.blue)
                    }
                    .font(.title)
                } else {
                    Button(action: {
                    }) {
                        Image(systemName: "stop.fill").onTapGesture {
                            self.audioPlayer.stopPlayBack()
                        }
                        .imageScale(.large)
                        .foregroundColor(.blue)
                    }
                    .font(.title)
                }
                
                //15秒進める。
                Button(action: {
                }) {
                    Image(systemName: "goforward.15").onTapGesture {
                        audioPlayer.audioPlayer.currentTime += 15
                    }
                    .imageScale(.medium)// システムアイコンを指定
                    .foregroundColor(.blue)
                }
                .font(.title)
                
                Button(action: {
                    print("")
                }) {
                    Text("")
                }
                
                
                
                
            }
        }
    }
}
//}




struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
