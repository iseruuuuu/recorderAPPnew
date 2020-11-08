import SwiftUI
import Speech
import MediaPlayer
import AVKit
import AVFoundation
import Combine
import MobileCoreServices

//onappearは、押された時にsliderを出せるようにする。のちに実装。
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
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    
    
    /*
     var progress1: UISlider!
     var nowTimeLabel: UILabel!
     var endTimeLabel: UILabel!
     var timer: Timer!
     var ButtonAudioURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "ButtonAudio", ofType: "wav")!)
     var ButtonAudioPlayer = AVAudioPlayer()
     //contentsOf: URL, fileTypeHint: nilの中身が内容
     //var ButtonAudioPlayer = AVAudioPlayer(contentsOf: URL, fileTypeHint: nil)
     //総再生時間、現在の再生時なっくぉ取得 audioURL: recording.fileURL
     let documentPath: AVAudioFile = try AVAudioFile(forReading: URL)
     let sampleRate = audioFile.fileFormat.sampleRate
     // let audioFile: AVAudioFile = try AVAudioFile(forReading: URL)
     let duration = Double(audioFile.length) / sampleRate
     
     */
    
    /*
     
     //Sliderのため
     //@StateObject var homeData : HomeViewModel!//(audioPlayer: audioPlayer)
     @State var timer = Timer.publish(every: 0.5, on: .current, in: .default).autoconnect()
     private let secondaryGray: Color = .init(white: 0.75)
     @State var timeObserverToken: Any?
     var itemDuration: Double = 0
     
     func updateTimer(){
     let currentTime = audioPlayer.audioPlayer.currentTime
     let total = audioPlayer.audioPlayer.duration
     let progress = currentTime / total
     withAnimation(Animation.linear(duration: 0.1)){
     self.angle = Double(progress) * 288
     }
     }
     
     
     private func updateSlider() {
     let time = AudioPlayer.currentItem?.currentTime() ?? CMTime.zero
     if itemDuration != 0 {
     slider.value = Float(CMTimeGetSeconds(time) / itemDuration)
     }
     }
     
     mutating func replacePlayerItem(fileName: String, fileExtension: String) {
     guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
     print("Url is nil")
     return
     }
     
     let asset = AVAsset(url: url)
     itemDuration = CMTimeGetSeconds(asset.duration)
     
     let item = AVPlayerItem(url: url)
     AudioPlayer.replaceCurrentItem(with: item)
     
     
     }
     
     private func changePosition(time: CMTime) {
     let rate = AudioPlayer.rate
     // いったんplayerをとめる
     AudioPlayer.rate = 0
     // 指定した時間へ移動
     AudioPlayer.seek(to: time, completionHandler: {_ in
     // playerをもとのrateに戻す(0より大きいならrateの速度で再生される)
     self.audioPlayer.rate = rate
     })
     }
     
     // MARK: Periodic Time Observer
     func addPeriodicTimeObserver() {
     // Notify every half second
     let timeScale = CMTimeScale(NSEC_PER_SEC)
     let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
     
     timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
     queue: .main)
     { [weak self] time in
     // update player transport UI
     DispatchQueue.main.async {
     print("update timer:\(CMTimeGetSeconds(time))")
     // sliderを更新
     self?.updateSlider()
     }
     }
     }
     
     
     func removePeriodicTimeObserver() {
     if let timeObserverToken = timeObserverToken {
     AudioPlayer.removeTimeObserver(timeObserverToken)
     self.timeObserverToken = nil
     }
     }
     
     */
    
    
    
    /*
     
     
     
     func viewDidLoad() {
     audioPlayer.audioPlayer.play()
     Slider.maxvalue = Float(audioPlayer.audioPlayer.duration)
     
     var Timer = Timer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateSlider"), userInfo: nil, repeats:true)
     }
     
     
     func updateSlider() {
     
     //     Slider.value = Float(audioPlayer.audioPlayer.currentTime)
     Slidervalue = Float(audioPlayer.audioPlayer.currentTime)
     NSLog("HI")
     }
     
     
     
     func slidertime() {
     
     Slider.maxValue = Float(audioPlayer.audioPlayer.duration)
     
     
     
     }
     audioPlayer.currentTime = TimeInterval(Slidervalue)
     self.audioPlayer.stopPlayBack()
     audioPlayer.audioPlayer.currentTime = time
     audioPlayer.currentTime =NSTimeInterval(slder.value)
     audioPlayer.currentTime =NSTimeInterval(sldervalue)
     audioPlayer.prepareToPlay()
     audioPlayer.audioPlayer.play()
     */
    
    //adding
    
    var progress1: UISlider!
    /*
     //UISliderクラスからインスタンスを生成→slider変数に格納
     var slider = UISlider()
     //生成したインスタンス「slider」に対してプロパティを指定
     slider.value = 1.0
     
     */
    
    /*
     //adding aonther version
     lazy var seekBar = UISlider()
     
     // Create AVPlayer
     let playerItem: AVAudioPlayer = AVAudioPlayer()
     //var audioPlayer = AudioPlayer()
     
     
     
     
     
     func audioseekbar() {
     
     // Add AVPlayer
     let layer = AVAudioPlayer()
     layer.videoGravity = AVLayerVideoGravity.resizeAspect
     layer.player = audioPlayer
     layer.frame = view.bounds
     view.layer.addSublayer(layer)
     
     // Create Movie SeekBar
     seekBar.frame = CGRect(x: 0, y: 0, width: view.bounds.maxX - 100, height: 50)
     seekBar.layer.position = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 100)
     seekBar.minimumValue = 0
     seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
     seekBar.addTarget(self, action: #selector(onSliderValueChange), for: UIControl.Event.valueChanged)
     view.addSubview(seekBar)
     
     // Set SeekBar Interval
     let interval : Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
     
     // ConvertCMTime
     let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
     
     // Observer
     videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
     // Change SeekBar Position
     let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
     let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
     let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
     self.seekBar.value = value
     })
     }
     */
    
    
    
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
    //  var minSlider = formatTime(sec: Int(00.00))
    //  var minSlider = formatTime(sec: Int(00.00))
    
    
    
    
    
    //maniumの動かすと初めになる。
    //  var maxSlider = 100.0
    
    @State var timeObserverToken: Any?
    
    func ViewDidLoad() {
        self.audioPlayer.startPlayBack(audio: self.audioURL)
        
        //SlidermaximumValue = Float(audioPlayer.audioPlayer.duration)
        
        //   var Timer = scheduledTimerWithTimerInterval(0.1, target: self, selector: Selector("updateSlider"), userInfo:nil, repeats: true)
    }
    
    
    
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
    
    func updateTime() {
        //        Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        slider.maximumValue = Float(audioPlayer.audioPlayer.duration)
        totaltime.text = stringFormatterTimeInterval(interval: audioPlayer.audioPlayer.duration) as String
    }
    func stringFormatterTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let second = ti / 60
        let minute = (ti / 60) % 60
        return NSString(format: "%0.2d:%0.2d", minute,second)
    }
    
    func update (_timer : Timer) {
        slider.value = Float(audioPlayer.audioPlayer.currentTime)
        timetime.text = stringFormatterTimeInterval(interval: TimeInterval(slider.value)) as String
    }
    
    /*
     
     
     func updateAudioProgressView(value: DragGesture.Value) {
     if audioPlayer.isPlaying {
     //UPdate progeress
     //
     let total = Float(audioPlayer.audioPlayer.duration/60)
     let currenttime = Float(audioPlayer.audioPlayer.currentTime/60)
     progress1.minimumValue = 0.0
     progress1.maximumValue = Float(audioPlayer.audioPlayer.duration)
     progress1.setValue(Float(audioPlayer.audioPlayer.currentTime),animated: true)
     }
     }
     */
    
    func onChanging(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: 0)
        
        
        //CGPointは、2時元座標系の点を含む構造
        //CGSizeは、幅と高さの値を含む構造
        //    let straight = CGPoint(vector.dx - 12)
        
        //    let straight = CGSize(vector.dx - 12)
        
        let straight = CGFloat(vector.dx)
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
        if audioPlayer.isPlaying {
            audioPlayer.audiopause()
        }else {
            self.audioPlayer.startPlayBack(audio: self.audioURL)
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

    
    
/*
 // 使える？？？
 func getCurrentTime(value: TimeInterval)->String{
 return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
 }
 
 */


//スライダーの実装ができたけど、動かすと最初の位置に戻る。

var body: some View {
    VStack(alignment:.center){
        Text("\(audioURL.lastPathComponent)")
            .font(.body)
            .padding(0)
        
        
        
        VStack(spacing: 0) {
            //inの中を録音の時間にする。
            //スライドするたびに、再生時間が最初に戻る。
            //再生時間が最初に戻る理由としては、一時停止がないから
         
            
       /*
            
            Slider(value: $sliderValue ,in: minSlider...maxSlider, step: 10, onEditingChanged: {_ in
                if audioPlayer.isPlaying == true {
                    //  self.audioPlayer.pauseplay()
                    self.audioPlayer.playprogress()
                    //  self.audioPlayer.playupdown()
                    //  self.audioPlayer.audioSlider2()
                    
                    
                    
                    /* if audioPlayer.isPlaying == false {
                     self.audioPlayer.startPlayBack(audio: self.audioURL)
                     */
                }else {
                    Slider(value: $nomove ,in: minSlider...maxSlider, step: 1)
                }
            } )
 */
            
            
            //追加したもおの
            Slider(value: Binding(get: {time}, set: { (newValue) in
                
                time = newValue
                
                audioPlayer.audioPlayer.currentTime = Double(time) * audioPlayer.audioPlayer.duration
                
                //設定の変更あり？
                self.audioPlayer.startPlayBack(audio: self.audioURL)
            }))
            
            .onReceive(timer) { (_) in
                if audioPlayer.isPlaying {
                    //audioPlayer.updateMeters()
                    audioPlayer.audioPlayer.updateMeters()
                    audioPlayer.isPlaying = true
                    
                    time = Float(audioPlayer.audioPlayer.currentTime / audioPlayer.audioPlayer.duration)
                    
                    startAnimation()
                }else {
                    audioPlayer.isPlaying = false
                }
            }
            
            
            
            
            /*
             Slider(value: $seekPos, onEditingChanged: { _ in
             guard let item = self.audioPlayer.audioPlayer.currentTime else {
             return
             }
             
             let targetTime = self.seekPos * audioPlayer.audioPlayer.duration
             self.audioPlayer.audioPlayer(to: CMTime(seconds: targetTime, preferredTimescale: 600))
             })
             */
            
            //
            // Slider(value: $currentTime, in: )
            //.gesture(DragGesture().onChanged(homeData.onChanged(value:)))changeTime
            
            //   .gesture(DragGesture().changeTimed(changeTimed(value: )))
            
            ///  .gesture(DragGesture().onChanged(onChanged(value: )))
            
            //   .gesture(AnyObject().changeTime(changeTime(value: Slider)))
            //   .frame(width: 300)
            //.accentColor(secondaryGray)
            
            
            
            HStack {
                // Text(verbatim: homeData.getCurrentTime(value: homeData.audioPlayer.currentTime))
                //  Text(formatTime(sec: Int(audioPlayer.audioPlayer.currentTime * currentTime)))
                // Text(verbatim: getCurrentTime(value: audioPlayer.audioPlayer.currentTime))
                //使う率が高い
                //   Text(verbatim: getCurrentTime(value: currentTime))
                
                Text("\(sliderValue)")
                    
                    
                    // Text(verbatim: getCurrentTime(value: ))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(100-sliderValue)")
                    
                    
                    //使う率が高い
                    //   Text(verbatim: getCurrentTime(value: currentTime))
                    
                    
                    //  Text(formatTime(sec: Int(currentTime * (1 - currentTime))))
                    //  Text("-" + formatTime(sec: Int(audioPlayer.audioPlayer.currentTime * (1 - currentTime))))
                    // Text(verbatim: getCurrentTime(value: audioPlayer.audioPlayer.duration))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                
                
            }
            
        }
        
        
        
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
         }
         */
        
        
        
        
        
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
            Image(systemName: "gobackward.15")
                .onTapGesture {
                    audioPlayer.audioPlayer.currentTime -= 5
                }
                .imageScale(.medium)
                .foregroundColor(.blue)
            // システムアイコンを指定
        }
        
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
                Image(systemName: "pause").onTapGesture {
                    
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
            Image(systemName: "goforward.15").onTapGesture {
                audioPlayer.audioPlayer.currentTime += 5
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
