

import SwiftUI
import Speech
import MediaPlayer
import AVKit
import AVFoundation
import Combine
import MobileCoreServices

//エラー一覧
/*
 再生以外にスライダーを触るとエラーが出る　　　　　　　！！解決！！
 スラーイダーが終わった後に触ると変になる       !!解決？？？！！！！
 再生ボタンを押して、一時停止を押しても、変わらない。　　　！！！ボイスメモも同じだから仕方がない？？！！！！！
 バックグラウンドができない。    !!!実機だとできないが、シュミレーターではできる!!!!
 実機で行うと録音が少ししかできない。。。！！！！！実機ではできないが、シュミレーターではできる。！！！！
 時間の表示 　            !!達成！！！！！!
 
 
 
 未達成
 
 一時停止の絵が変わらない。
 
 */


struct RecordingsList: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var value: Double = 0
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL, audioRecorder: audioRecorder)
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
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    //sliderの設置
    @State var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    //再生時間の表示
    @State var starttime : Float = 0
    @State var finishtime : Float = 0
    //再生時以外に動かしても意味なないもの
    @State var nomove = 0.0
    
    
    func play() {
        if audioPlayer.isPlaying == true {
            audioPlayer.audiopause()
            self.audioPlayer.startPlayBack(audio: self.audioURL)
            // audioPlayer.pauseplay()
        }else {
            audioPlayer.pauseplay()
        }
    }
    
    func startAnimation() {
        var power : Float = 0
        for i in 0..<audioPlayer.audioPlayer.numberOfChannels{
            power += audioPlayer.audioPlayer.averagePower(forChannel: i)
        }
        let value = max(0, power + 55)
        let animated = CGFloat(value) * (maxWidth / 55)
        withAnimation(Animation.linear(duration: 0.01)) {
            self.animatedValue = animated + 55
        }
    }
    
    //再生時間を表示
    func getStartTime(value: TimeInterval)->String{
        return "\(Int(starttime / 60)):\(Int(starttime.truncatingRemainder(dividingBy: 60)) < 10 ? "0" : "")\(Int(starttime.truncatingRemainder(dividingBy: 60)))"
    }
    
    
    func getFinishTime(value: TimeInterval)-> String {
        return "\(Int(finishtime / 60)):\(Int(finishtime.truncatingRemainder(dividingBy: 60)) < 10 ? "0" : "")\(Int(finishtime.truncatingRemainder(dividingBy: 60)))"
    }
    
    
    var body: some View {
        VStack(alignment:.center){
            Text("\(audioURL.lastPathComponent)")
                .font(.body)
                .padding(0)
            VStack(spacing: 0) {
                ZStack {
                    if audioPlayer.isPlaying == false {
                        Slider(value: $nomove ,in: 1...100, step: 1)
                    }else {
                        Slider(value: Binding(get: {time}, set: { (newValue) in
                            time = newValue
                            audioPlayer.audioPlayer.currentTime = Double(time) * audioPlayer.audioPlayer.duration
                            self.audioPlayer.pauseplay()
                        }))
                        .onReceive(timer) { (_) in
                            if audioPlayer.isPlaying {
                                audioPlayer.audioPlayer.updateMeters()
                                audioPlayer.isPlaying = true
                                time = Float(audioPlayer.audioPlayer.currentTime / audioPlayer.audioPlayer.duration)
                                
                                starttime = Float(audioPlayer.audioPlayer.currentTime)
                                
                                finishtime = Float(audioPlayer.audioPlayer.duration - audioPlayer.audioPlayer.currentTime)
                                
                                startAnimation()
                                
                            } else {
                                audioPlayer.isPlaying = false
                            }
                        }
                    }
                }
                
                HStack {
                    if audioPlayer.isPlaying == true {
                        Text(getStartTime(value: TimeInterval(starttime)))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }else {
                        Text("0:00")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(getFinishTime(value: TimeInterval(finishtime)))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
        }
        
        
        HStack(spacing: 42){
            //戻る機能
            Button(action: {
            }) {
                Image(systemName: "backward.fill")
                    .onTapGesture {
                        if audioPlayer.isPlaying == true {
                            audioPlayer.audioPlayer.currentTime -= 10000
                        }
                        else {
                            Button(action: {
                            }) {
                                Image(systemName: "backward.fill")
                                Text("")
                            }
                        }
                    }
            }
            .imageScale(.medium)
            .foregroundColor(.blue)
            .font(.title)
            
            //15秒戻る機能
            Button(action: {
            }) {
                Image(systemName: "gobackward.10")
                    .onTapGesture {
                        if audioPlayer.isPlaying == true {
                            audioPlayer.audioPlayer.currentTime -= 10
                        }
                        else {
                            Button(action: {
                            }) {
                                Image(systemName: "gobackward.10")
                                Text("")
                            }
                        }
                    }
            }
            .imageScale(.medium)
            .foregroundColor(.blue)
            .font(.title)
            
            /*念の為残していく
             
             Button(action: {
             }) {
             Image(systemName: "goforward.15").onTapGesture {
             self.audioPlayer.pauseplay()
             }
             .imageScale(.medium)// システムアイコンを指定
             .foregroundColor(.blue)
             }
             .font(.title)
             
             */
            
            /*
             //一時停止機能。
             Button(action: {
             }) {
             Image(systemName: "pause").onTapGesture {
             self.audioPlayer.pauseplay()
             }
             .imageScale(.medium)// システムアイコンを指定
             .foregroundColor(.blue)
             }
             .font(.title)
             
             */
            
            //再生の処理
            if audioPlayer.isPlaying == false {
                Button(action: {
                }) {
                    Image(systemName: "play.fill")
                        //  Image(systemName: homeData.isPlaying ? "pause.fill" : "play.fill")
                        .onTapGesture{
                            //再生するためのもの
                            self.audioPlayer.startPlayBack(audio: self.audioURL)
                        }
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .font(.title)
                /*
                 if audioPlayer.isPlaying == true {
                 Image(systemName: "pause")
                 }
                 */
                
            } else {
                Button(action: {
                }) {
                    
                    ZStack {
                        
                        Image(systemName: "pause")
                        
                    }
                    .onTapGesture {
                        //   Image(systemName: "pause" : systemName: "play.circle").onTapGesture {
                        self.audioPlayer.pauseplay()
                    }
                    .imageScale(.large)
                    .foregroundColor(.blue)
                }
                .font(.title)
            }
            
            
            //15秒進める。
            Button(action: {
            }) {
                Image(systemName: "goforward.10").onTapGesture {
                    if audioPlayer.isPlaying == true {
                        audioPlayer.audioPlayer.currentTime += 10
                    }
                    else {
                        Button(action: {
                        }) {
                            Image(systemName: "gobackward.10")
                        }
                    }
                    
                }
                .imageScale(.medium)
                .foregroundColor(.blue)
            }
            .font(.title)
            
            
            Button(action: {
            }) {
                Image(systemName: "forward.fill").onTapGesture {
                    if audioPlayer.isPlaying == true {
                        audioPlayer.audioPlayer.currentTime += 10000
                    }
                    else {
                        Button(action: {
                        }) {
                            Image(systemName: "forward.fill")
                        }
                    }
                }
                .imageScale(.medium)// システムアイコンを指定
                .foregroundColor(.blue)
            }
            .font(.title)
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
