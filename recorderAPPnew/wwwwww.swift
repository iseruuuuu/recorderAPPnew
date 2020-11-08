/*


// ContentView

import SwiftUI

struct ContentView: View {
  var body: some View {
      Home()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}

// Home

import SwiftUI

struct Home: View {
  @StateObject var homeData = HomeViewModel()
  // For Smaller Size Phones
  @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
  @State var timer = Timer.publish(every: 0.5, on: .current, in: .default).autoconnect()
  var body: some View {
      
      VStack{
          
          // TOpView....
          
          HStack{
              
              Button(action: {}) {
                  
                  Image(systemName: "chevron.left")
                      .font(.title2)
                      .foregroundColor(.black)
              }
              
              Spacer(minLength: 0)
              
              Button(action: {}) {
                  
                  Image(systemName: "magnifyingglass")
                      .font(.title2)
                      .foregroundColor(.black)
              }
          }
          .padding()
          
          VStack{
              
              Spacer(minLength: 0)
              
              ZStack{
                  
                  // Album Image...
                  Image(uiImage: homeData.album.artwork)
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: width, height: width)
                      .clipShape(Circle())
                  
                  ZStack{
                      
                      // SLider...
                      Circle()
                          .trim(from: 0, to: 0.8)
                          .stroke(Color.black.opacity(0.06),lineWidth: 4)
                          .frame(width: width + 45, height: width + 45)
                      
                      Circle()
                          .trim(from: 0, to: CGFloat(homeData.angle) / 360)
                          .stroke(Color("orange"),lineWidth: 4)
                          .frame(width: width + 45, height: width + 45)
                      
                      // Slider Circle...
                      
                      Circle()
                          .fill(Color("orange"))
                          .frame(width: 25, height: 25)
                          // Moving View...
                          .offset(x: (width + 45) / 2)
                          .rotationEffect(.init(degrees: homeData.angle))
                      // gesture...
                          .gesture(DragGesture().onChanged(homeData.onChanged(value:)))
                      
                      
                  }
                  // Rotating View For Bottom Facing...
                  // Mid 90 deg + 0.1*360 = 36
                  // total 126
                  .rotationEffect(.init(degrees: 126))
                  
                  // Time Texts....
                  
                  Text(homeData.getCurrentTime(value: homeData.player.currentTime))
                      .fontWeight(.semibold)
                      .foregroundColor(.black)
                      .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85 , y: (width + 70) / 2)
                  
                  Text(homeData.getCurrentTime(value: homeData.player.duration))
                      .fontWeight(.semibold)
                      .foregroundColor(.black)
                      .offset(x: UIScreen.main.bounds.height < 750 ? 65 : 85 , y: (width + 70) / 2)
              }
              
              Text(homeData.album.title)
                  .font(.title2)
                  .fontWeight(.heavy)
                  .foregroundColor(.black)
                  .padding(.top,30)
                  .padding(.horizontal)
                  .lineLimit(1)
              
              Text(homeData.album.artist)
                  .foregroundColor(.gray)
                  .padding(.top,5)
              
              Text(homeData.album.type)
                  .font(.caption)
                  .fontWeight(.bold)
                  .foregroundColor(.black)
                  .padding(.vertical,6)
                  .padding(.horizontal)
                  .background(Color.black.opacity(0.07))
                  .cornerRadius(5)
                  .padding(.top)
              
              HStack(spacing: 55){
                  
                  Button(action: {}) {
                      
                      Image(systemName: "backward.fill")
                          .font(.title)
                          .foregroundColor(.gray)
                  }
                  
                  Button(action: homeData.play) {
                      
                      Image(systemName: homeData.isPlaying ? "pause.fill" : "play.fill")
                          .font(.title)
                          .foregroundColor(.white)
                          .padding(20)
                          .background(Color("orange"))
                          .clipShape(Circle())
                  }
                  
                  Button(action: {}) {
                      
                      Image(systemName: "forward.fill")
                          .font(.title)
                          .foregroundColor(.gray)
                  }
              }
              .padding(.top,25)
              
              //Volume Control....
              
              HStack(spacing: 15){
                  
                  Image(systemName: "minus")
                      .foregroundColor(.black)
                  
                  ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                      
                      Capsule()
                          .fill(Color.black.opacity(0.06))
                          .frame(height: 4)
                      
                      Capsule()
                          .fill(Color("orange"))
                          .frame(width: homeData.volume, height: 4)
                      
                      // Slider....
                      
                      Circle()
                          .fill(Color("orange"))
                          .frame(width: 20, height: 20)
                      // gesture....
                          .offset(x: homeData.volume)
                          .gesture(DragGesture().onChanged(homeData.updateVolume(value:)))
                  }
                  // default Frame...
                  .frame(width: UIScreen.main.bounds.width - 160)
                  
                  Image(systemName: "plus")
                      .foregroundColor(.black)
              }
              .padding(.top,25)
              
              Spacer(minLength: 0)
          }
          .frame(maxWidth: .infinity)
          .background(Color("bg"))
          .cornerRadius(35)
          
          HStack(spacing: 0){
              
              ForEach(buttons,id: \.self){name in
                  
                  Button(action: {}) {
                      Image(systemName: name)
                          .font(.title2)
                          .foregroundColor(.white)
                  }
                  
                  if name != buttons.last{Spacer(minLength: 0)}
              }
          }
          .padding(.horizontal,35)
          .padding(.top,25)
          .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom != 0 ? 5 : 15)
      }
      .background(
      
          VStack{
              Color("Color")
              Color("Color1")
          }
          .ignoresSafeArea(.all, edges: .all)
      )
      // fetching album Data...
      .onAppear(perform: homeData.fetchAlbum)
      .onReceive(timer) { (_) in
          homeData.updateTimer()
      }
  }
  
  // Buttons....
  var buttons = ["suit.heart.fill","star.fill","eye.fill","square.and.arrow.up.fill"]
  
}

// Album

import SwiftUI

struct Album {
  var title : String = ""
  var artist : String = ""
  var type : String = ""
  var artwork : UIImage = UIImage(named: "music")!
}

// HomeViewModel

import SwiftUI
import AVKit

let url = URL(fileURLWithPath: Bundle.main.path(forResource: "audio", ofType: "mp3")!)

class HomeViewModel : ObservableObject{
  
  @Published var player = try! AVAudioPlayer(contentsOf: url)
  
  @Published var isPlaying = false
  
  @Published var album = Album()
  
  @Published var angle : Double = 0
  
  @Published var volume : CGFloat = 0
  
  func fetchAlbum(){
      
      let asset = AVAsset(url: player.url!)
      
      asset.metadata.forEach { (meta) in
          
          switch(meta.commonKey?.rawValue){
          
          case "title": album.title = meta.value as? String ?? ""
          case "artist": album.artist = meta.value as? String ?? ""
          case "type": album.type = meta.value as? String ?? ""
          case "artwork": if meta.value != nil{album.artwork = UIImage(data: meta.value as! Data)!}
          default: ()
          }
      }
      
      // fetching audio volume level...
      
      volume = CGFloat(player.volume) * (UIScreen.main.bounds.width - 180)
  }
  
  func updateTimer(){
      
      let currentTime = player.currentTime
      let total = player.duration
      let progress = currentTime / total
      
      withAnimation(Animation.linear(duration: 0.1)){
          
          self.angle = Double(progress) * 288
      }
      isPlaying = player.isPlaying
  }
  
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
          let time = TimeInterval(progress) * player.duration
          player.currentTime = time
          player.play()
          withAnimation(Animation.linear(duration: 0.1)){self.angle = Double(angle)}
      }
  }
  
  func play(){
      
      if player.isPlaying{player.pause()}
      else{player.play()}
      isPlaying = player.isPlaying
  }
  
  func getCurrentTime(value: TimeInterval)->String{
      
      return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
  }
  
  func updateVolume(value: DragGesture.Value){
      
      // Updating Volume....
      
      // 160 width 20 circle size...
      // total 180
      
      if value.location.x >= 0 && value.location.x <= UIScreen.main.bounds.width - 180{
          
          // updating volume...
          let progress = value.location.x / UIScreen.main.bounds.width - 180
          player.volume = Float(progress)
          withAnimation(Animation.linear(duration: 0.1)){volume = value.location.x}
      }
  }
}

 
 
 */
