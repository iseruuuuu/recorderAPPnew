




import SwiftUI
import Speech
import MediaPlayer
import AVKit
import AVFoundation





struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State private var value: Double = 0
    
    /*
     //シークバーの設置
     @State var seekPos = 0.0
     */
    
    /*
    @State var time: TimeInterval
    init() {
        _time = .init(initialValue: 0)
    }
 */
    

    
    
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


struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        // HStack(alignment:.center) {
        VStack(alignment:.center){
            
            
            Text("\(audioURL.lastPathComponent)")
                .font(.body)
            
                /*シークバーの設置
             func changePosition(time: CMTime) {
                let rate = player.rate
                // いったんplayerをとめる
                player.rate = 0
                // 指定した時間へ移動
                player.seek(to: time, completionHandler: {_ in
                    // playerをもとのrateに戻す(0より大きいならrateの速度で再生される)
                    self.player.rate = rate
                })
            }
 */
         /*
            return Silder(value:self.$time) {
                EmptyView()
            }
            */
            
           /*
            VStack {
                Slider(value: $value, in: 0...100)
                Text("現在の値:\(value)")
            }
            
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
