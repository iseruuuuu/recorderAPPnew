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



