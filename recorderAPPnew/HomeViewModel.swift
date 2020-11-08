// HomeViewModel
/*
import SwiftUI
import AVKit

//let url = URL(fileURLWithPath: Bundle.main.path(forResource: "audio", ofType: "mp3")!)

class HomeViewModel : ObservableObject{
    
    
    
    //@Published var isPlaying = false
    
    @Published var angle : Double = 0
    
    @Published var volume : CGFloat = 0
    
    var audioPlayer: AudioPlayer!
  
    // fetching audio volume level...
    
    
    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
        
    }






//使うのかな？
func updateTimer(){
    
    
    
    let currentTime = AudioPlayer.currentTime
    let total = audioPlayer.duration
    _ = currentTime / total
    
    // withAnimation(Animation.linear(duration: 0.1)){}
}
 
 
 
 
 
 
    
    


//Sliderにおいて必須？？
func onChanged(value: DragGesture.Value){
    let vector = CGVector(dx: value.location.x, dy: value.location.y)
    // 12.5 = 25 => Circle Radius...
    let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
    let tempAngle = radians * 180 / .pi
    let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
    // since maximum slide is 0.8
    // 0.8*36 = 288
    if angle <= 288{
    // getting time...
    let progress = angle / 288
    let time = TimeInterval(progress) * audioPlayer.duration
    audioPlayer.currentTime = time
    audioPlayer.play()
      withAnimation(Animation.linear(duration: 0.1)){self.angle = Double(angle)}
}
}



    
    
    

// 使える？？？
func getCurrentTime(value: TimeInterval)->String{
    return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
}


}

*/
