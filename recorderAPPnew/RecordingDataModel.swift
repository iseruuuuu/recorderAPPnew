//
//  RecordingDataModel.swift
//  recorderAPPnew
//
//  Created by user on 2020/10/11.
//

import Foundation


struct Recording {
    let fileURL: URL
    let createdAt: Date
}

/*
private func changePosition(time: CMTime) {
    let rate = AudioPlayer.rate
    AudioPlayer.rate = 0
    AudioPlayer.seek(to: time,completionHandler: {_ in
        self.AudioPlayer.rate = rate
    })
}
*/
