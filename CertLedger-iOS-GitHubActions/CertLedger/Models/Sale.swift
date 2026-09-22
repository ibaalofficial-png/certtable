import Foundation
import SwiftData

@Model
final class Sale {
    var date: Date
    var udid: String
    var device: String
    var cost: Double
    var salePrice: Double
    var status: String

    init(date: Date = .now, udid: String, device: String, cost: Double, salePrice: Double, status: String = "Lunas") {
        self.date = date
        self.udid = udid
        self.device = device
        self.cost = cost
        self.salePrice = salePrice
        self.status = status
    }

    var profit: Double { salePrice - cost }
}
