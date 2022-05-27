//
//  Model.swift
//  Hotel Manzana
//
//  Created by Vladimir Pisarenko on 26.05.2022.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var eMailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wiFi: Bool
    var roomType: RoomType
}

struct RoomType: Equatable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}
