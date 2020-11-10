import SwiftUI
import Speech
import MediaPlayer
import AVKit
import AVFoundation
import Combine
import MobileCoreServices

//onappearは、押された時にsliderを出せるようにする。のちに実装。

//エラー一覧
/*
 
 ・再生以外にスライダーを触るとエラーが出る
 スラーイダーが終わった後に触ると変になる
 ・再生ボタンを押して、一時停止を押しても、変わらない。
 バックグラウンドさせifができない。
 
 */




struct RecordingsList: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var value: Double = 0
    @State var angle : Double = 0
    @State var timeObserverToken: Any?
    var progress1: UISlider!
    
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
    @ObservedObject var audioRecorder: AudioRecorder
    
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var  currentTime: Double = 0.3
    // @State private var currentTimes: Double = 0.2
    @State private var currentVolume: Double = 0.5
    
    //addding
    @State private var total: Double = 0.3
    @State private var progress: Double = 0.3
    
    //したのものを為にオフにしといた。
    //  @State private var time: Double = 0.3
    @State var angle : Double = 0
    
    
    
    
    //動画の「やつ！！！多分イバン信頼でくる！！！！！！１
    // @State var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    @State var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    @State var finishtime : Float = 0
    
    
    
    
    //adding
    
    var progress1: UISlider!
    
    
    
    
    
    func getAudioFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("record.m4a")
        return audioUrl
        
    }
    
    
    
    
    //スライダが動くためのもの
    @State var sliderValue = 0.0
    @State var SliderValue = AudioPlayer()
    //再生時以外に動かしても意味なないもの
    @State var nomove = 0.0
    
    
    var maxSlider = 60.0
    var minSlider = 0.0
    
    @State var seekPos = 0.0
    
    
    
    
    
    //maniumの動かすと初めになる。
    //  var maxSlider = 100.0
    
    @State var timeObserverToken: Any?
    
    
    
    
    //長さが100になった。割合が100％ = 100,0
    
    func changeTime(sender:AnyObject) {
        // slidermaximumValue = Float(audioPlayer.audioPlayer.duration)
        audioPlayer.stopPlayBack()
        audioPlayer.audioPlayer.currentTime = TimeInterval(sliderValue)
        audioPlayer.audioPlayer.prepareToPlay()
        self.audioPlayer.startPlayBack(audio: self.audioURL)
    }
    
    
    func changeTimed(value: DragGesture.Value) {
        print(value)
        //  Slider.maximumValue = Float(audioPlayer.audioPlayer.duration)
        audioPlayer.stopPlayBack()
        audioPlayer.audioPlayer.currentTime = TimeInterval(sliderValue)
        audioPlayer.audioPlayer.prepareToPlay()
        self.audioPlayer.startPlayBack(audio: self.audioURL)
    }
    
    
    func updateSlider() {
        sliderValue = Double(Float(audioPlayer.audioPlayer.currentTime))
    }
    
    func timeToString(time: TimeInterval) -> String {
        let second: Int
        let minute: Int
        second = Int(time) % 60
        minute = Int(time) / 60
        return "\(minute):\(NSString(format: "%02d", second))"
    }
    
    let slider : UISlider = {
        let slider = UISlider()
        //maximumValueの値が100%の値
        slider.maximumValue = 100
        //maniumの動かすと初めになる。
        //  slider.minimumValue = 0
        //     slider.minimumValue = audioPlayer.pauseplay()
        //   slider.addTarget(self, action: #selector(_slider), for: .touchDragInside)
        return slider
    }()
    
    let timetime : UILabel = {
        let label = UILabel()
        label.text = "-:--"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let totaltime : UILabel = {
        let label = UILabel()
        label.text = "-:--"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blue
        return label
    }()
    
    func _slider () {
        if audioPlayer.isPlaying == true {
            self.audioPlayer.pauseplay()
            audioPlayer.audioPlayer.currentTime = TimeInterval(slider.value)
            self.audioPlayer.startPlayBack(audio: self.audioURL)
        }else {
            audioPlayer.audioPlayer.currentTime = TimeInterval(slider.value)
        }
    }
    
    
    
    
    
    
    
    func onChanging(value: DragGesture.Value) {
        //    let vector = CGVector(dx: value.location.x, dy: 0)
        
        
        //CGPointは、2時元座標系の点を含む構造
        //CGSizeは、幅と高さの値を含む構造
        //    let straight = CGPoint(vector.dx - 12)
        
        //    let straight = CGSize(vector.dx - 12)
        
        //  let straight = CGFloat(vector.dx)
        //直線の公式？
        //    let targetTime = self.seekPos * item.duration.seconds
        //    self.player.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))
        
        /*
         //合ってる？？？！１
         let screenWidth = UIScreen.main.bounds.width - 20
         let currenttime = self.audioPlayer.audioPlayer.currentTime / self.audioPlayer.audioPlayer.duration
         let timeForLabel = CGFloat(currenttime) * screenWidth
         self.time = Double(timeForLabel)
         print(currenttime)
         
         
         */
        
    }
    
    
    
    
    
    /*
     
     //再生のバーに影響あり？ これは、円の式だから、直線にする必要ある
     func onChanged(value: DragGesture.Value){
     print(value)
     let vector = CGVector(dx: value.location.x, dy: value.location.y)
     // 12.5 = 25 => Circle Radius...
     
     let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
     //.piは、円周率
     let tempAngle = radians * 180 / .pi
     let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
     // since maximum slide is 0.8
     // 0.8*36 = 288
     if angle <= 288{
     // getting time...
     let progress = angle / 288
     let time = TimeInterval(progress) * audioPlayer.audioPlayer.duration
     audioPlayer.audioPlayer.currentTime = time
     audioPlayer.pauseplay()
     // audioPlayer.audioPlayer.play()
     withAnimation(Animation.linear(duration: 0.1)){
     self.angle = Double(angle)}
     
     //  AudioPlayer.currentTime = TimeInterval(Slider.value)
     }
     }
     */
    
    func audioSlider1() {
        if minSlider  <= 1 {
            audioPlayer.audioPlayer.currentTime += 1
        }else {
            audioPlayer.audioPlayer.currentTime -= 1
        }
    }
    
    func audioSlider2() {
        if minSlider < maxSlider {
            audioPlayer.audioPlayer.currentTime += 1
        }else {
            audioPlayer.audioPlayer.currentTime -= 1
        }
    }
    
    
    
    
    
    
    func play() {
        if audioPlayer.isPlaying == true {
            audioPlayer.audiopause()
            self.audioPlayer.startPlayBack(audio: self.audioURL)
            audioPlayer.pauseplay()
        }else {
            audioPlayer.pauseplay()
            Slider(value: $nomove ,in: minSlider...maxSlider, step: 1)
        }
    }
    
    
    func startAnimation() {
        var power : Float = 0
        // for i in 0..<audioPlayer.numberOfChannels{
        for i in 0..<audioPlayer.audioPlayer.numberOfChannels{
            //  power += audioPlayer.averagePower(forCannel: i)
            power += audioPlayer.audioPlayer.averagePower(forChannel: i)
        }
        let value = max(0, power + 55)
        
        let animated = CGFloat(value) * (maxWidth / 55)
        
        withAnimation(Animation.linear(duration: 0.01)) {
            self.animatedValue = animated + 55
        }
    }
    
    func stringFormatterTimeInterval(interval: TimeInterval) -> NSString {
        let time = NSInteger(interval)
        let second = time / 60
        let minute = (time / 60) % 60
        return NSString(format: "%0.2d:%0.2d", minute,second)
    }
    
    
    
    // 使える？？？
    func getCurrentTime(value: TimeInterval)->String{
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
    }
    
    
    
    
    
    //スライダーの実装ができたけど、動かすと最初の位置に戻る。
    
    var body: some View {
        VStack(alignment:.center){
            Text("\(audioURL.lastPathComponent)")
                .font(.body)
                .padding(0)
            
            
            
            VStack(spacing: 0) {
                //      Slider(value: $プロパティ名, in: 最小値...最大値)
                
                /*
                 Slider(value: $sliderValue ,in: minSlider...maxSlider, step: 10, onEditingChanged: {_ in
                 if audioPlayer.isPlaying == true {
                 self.audioPlayer.playprogress()
                 
                 if audioPlayer.isPlaying == false {
                 self.audioPlayer.startPlayBack(audio: self.audioURL)
                 
                 }else {
                 Slider(value: $nomove ,in: minSlider...maxSlider, step: 1)
                 }
                 } )
                 */
                
                ZStack {
                //追加したもおの
                Slider(value: Binding(get: {time}, set: { (newValue) in
                    
                    
                    time = newValue
                    audioPlayer.audioPlayer.currentTime = Double(time) * audioPlayer.audioPlayer.duration
                    
                    //設定の変更あり？
                    // self.audioPlayer.startPlayBack(audio: self.audioURL)
                    self.audioPlayer.pauseplay()
                    //   self.audioPlayer.audioPlayer.play()
                }))
                .onReceive(timer) { (_) in
                    if audioPlayer.isPlaying {
                        //audioPlayer.updateMeters()
                        audioPlayer.audioPlayer.updateMeters()
                        audioPlayer.isPlaying = true
                        
                        time = Float(audioPlayer.audioPlayer.currentTime / audioPlayer.audioPlayer.duration)
                        
                        finishtime = Float(audioPlayer.audioPlayer.duration - audioPlayer.audioPlayer.currentTime)
                        
                        startAnimation()
                        
                    } else {
                        
                        audioPlayer.isPlaying = false
                       // Slider(value: $nomove ,in: minSlider...maxSlider, step: 1)
                    }
                  //  Slider(value: $nomove ,in: minSlider...maxSlider, step: 1)
                }
                
                    Slider(value: $nomove ,in: minSlider...maxSlider, step: 1)
                }
                
                
                /*
                 
                 
                 HStack {
                 // Text(verbatim: homeData.getCurrentTime(value: homeData.audioPlayer.currentTime))
                 //  Text(formatTime(sec: Int(audioPlayer.audioPlayer.currentTime * currentTime)))
                 // Text(verbatim: getCurrentTime(value: audioPlayer.audioPlayer.currentTime))
                 //使う率が高い
                 //   Text(verbatim: getCurrentTime(value: currentTime))
                 
                 Text("\(time)")
                 // Text(verbatim: getCurrentTime(value: ))
                 .fontWeight(.semibold)
                 .foregroundColor(.black)
                 Spacer()
                 Text("\(finishtime)")
                 
                 
                 //使う率が高い
                 //   Text(verbatim: getCurrentTime(value: currentTime))
                 
                 
                 //  Text(formatTime(sec: Int(currentTime * (1 - currentTime))))
                 //  Text("-" + formatTime(sec: Int(audioPlayer.audioPlayer.currentTime * (1 - currentTime))))
                 // Text(verbatim: getCurrentTime(value: audioPlayer.audioPlayer.duration))
                 .fontWeight(.semibold)
                 .foregroundColor(.black)
                 
                 
                 
                 }
                 
                 }
                 */
                
                
                /*
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
                 
                 */
                
            }
            
            
            
            
            
        }
        
        HStack(spacing: 60){
            
            //隙間を調整 (pauseの実装)
            /*
             Button(action: {
             // print("")
             }) {
             Image(systemName:"gobackward.15")
             .onTapGesture {
             self.audioPlayer.audioplaypause()
             }
             
             Text("")
             }
             */
            
            
            Button(action: {
                print("")
            }) {
                Text("")
            }
            
            
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
                                Text("ガンバ大阪")
                            }
                        }
                        
                        // システムアイコンを指定
                    }
                
            }
            .imageScale(.medium)
            .foregroundColor(.blue)
            .font(.title)
            
            
            
            /*
             
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
                    Image(systemName: "play.circle")
                        .onTapGesture{
                            //  self.audioPlayer.play()
                            //再生するためのもの
                            self.audioPlayer.startPlayBack(audio: self.audioURL)
                        }
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .font(.title)
            } else {
                Button(action: {
                }) {
                    
                    ZStack {
                        Image(systemName: "pause")
                        //   Image(systemName: "play.circle")
                    }
                    .onTapGesture {
                        //   Image(systemName: "pause" : systemName: "play.circle").onTapGesture {
                        
                        self.audioPlayer.pauseplay()
                        // self.audioPlayer.startPlayBack(audio: self.audioURL)
                        
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

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
