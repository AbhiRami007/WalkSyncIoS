//
//  Item.swift
//  WalkSync
//
//

import Foundation
import SwiftData

@Model
class Activity {
    @Attribute var id: UUID
    @Attribute var date: Date
    @Attribute var steps: Int
    @Attribute var walkingDistance: Double
    @Attribute var speed: Double

    init(date: Date, steps: Int, walkingDistance: Double, speed: Double) {
        self.id = UUID()
        self.date = date
        self.steps = steps
        self.walkingDistance = walkingDistance
        self.speed = speed
    }
}

