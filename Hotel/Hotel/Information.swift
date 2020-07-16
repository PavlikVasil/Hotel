//
//  Information.swift
//  Hotel
//
//  Created by Павел on 19.05.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct Information: Codable{
    var firstName: String
    var lastName: String
    var email: String
    var inDate: Date
    var outDate: Date
    var numberAdults: Int
    var numberChildren: Int
    var room: RoomType
    var wifi: Bool
    init(firstName: String, lastName: String, email: String, inDate: Date, outDate: Date, numberAdults: Int, numberChildren: Int, room: RoomType, wifi: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.inDate = inDate
        self.outDate = outDate
        self.numberAdults = numberAdults
        self.numberChildren = numberChildren
        self.room = room
        self.wifi = wifi
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveUrl = documentsDirectory.appendingPathComponent("information").appendingPathExtension("plist")

    static func saveToFile(information: [Information]){
        let propertylistEncoder = PropertyListEncoder()
        let codedInfo = try? propertylistEncoder.encode(information)
        try? codedInfo?.write(to: archiveUrl)
    }

    static func loadFromFile() -> [Information]? {
        guard let codedInfo = try? Data.init(contentsOf: archiveUrl) else {return nil}
        let propertylistDecoder = PropertyListDecoder()
        return try? propertylistDecoder.decode([Information].self, from: codedInfo)
    }
    
}


struct RoomType: Equatable, Codable{
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static var all: [RoomType]{
        return [RoomType(id: 0, name: "Two Beds", shortName: "TB", price: 169),
                RoomType(id: 1, name: "One Big Bed", shortName: "OBB", price: 200),
                RoomType(id: 2, name: "Two Big Beds", shortName: "TBB", price: 250)]
    }
    
}

func == (lhs: RoomType, rhs: RoomType) -> Bool{
    return lhs.id == rhs.id
}




