import UIKit
class StockTicker: NSObject {
    var ids: String? = ""
    var symbol: String? = ""
    var name: String? = ""
    var status: String? = ""
    var price: String? = ""
    var plp: String? = ""
    var open: String? = ""
    var high: String? = ""
    var low: String? = ""
    var volume: String? = ""
    var isWatchlisted: Bool?
    var prevDailyBar: DailyBar?

    init(ids: String, symbol: String, name: String, status: String, price: String, plp: String, open: String, high: String, low: String, volume: String, isWatchlisted: Bool, prevDailyBar: DailyBar?) {
        self.ids = ids
        self.symbol = symbol
        self.name = name
        self.status = status
        self.price = price
        self.plp = plp
        self.open = open
        self.high = high
        self.low = low
        self.volume = volume
        self.isWatchlisted = isWatchlisted
        self.prevDailyBar = prevDailyBar
    }
}

struct DailyBar {
    var c: Double
    var h: Double
    var l: Double
    var n: Int
    var o: Double
    var t: String
    var v: Int
    var vw: Double
}





