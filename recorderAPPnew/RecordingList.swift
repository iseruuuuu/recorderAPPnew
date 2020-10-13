





import SwiftUI
import AVKit




struct RecordingsList: View {
    
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    //シークバーの設置
    @State var seekPos = 0.0
    
    
    
    
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
                    .font(.title)
                
         /*
                
                HStack {
                    Text("00:00:00---")
                    Text("---00:00:00")
                }
        */
                
         /* 再生の手段
                Slider(value: $seekPos, from: 0, through: 1, onEditingChanged: { _ in
                  guard let item = self.audioRecorder.currentItem else {
                    return
                  }
                  let targetTime = self.seekPos * item.duration.seconds
                  self.audioRecorder.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))
                })
                
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
                            print("１５秒戻るよ！！")
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
                            print("１５秒進むよ！")
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
