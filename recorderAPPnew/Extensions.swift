//
//  Extensions.swift
//  recorderAPPnew
//
//  Created by user on 2020/10/11.
//

import SwiftUI



extension Date {
    func toString( dateFormat format : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        
        
        
        //ここは追加した物
        
        func timeToString(time: TimeInterval) -> String {
            let second: Int
            let minute: Int
            second = Int(time) % 60
            minute = Int(time) / 60
            return "\(minute):\(NSString(format: "%02d", second))"
        }
        
        
        
        
        func getDate()-> String {
            let time = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:ss"
            let stringDate = timeFormatter.string(from: time)
            return stringDate
        }
        
        
        
        return dateFormatter.string(from: self)
        
    }
}



