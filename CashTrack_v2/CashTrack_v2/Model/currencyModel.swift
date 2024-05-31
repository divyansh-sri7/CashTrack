//
//  currencyModel.swift
//  CashTrack_v2
//
//  Created by Divyansh Srivastava on 20/04/24.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable, Hashable {
    case usd = "USD"
    case aed = "AED"
    case eur = "EUR"
    case jpy = "JPY"
    case gbp = "GBP"
    case aud = "AUD"
    case cad = "CAD"
    case chf = "CHF"
    case cny = "CNY"
    case rub = "RUB"
    case inr = "INR"
    case brl = "BRL"
    case zar = "ZAR"
    case TRY = "TRY"
    case mxn = "MXN"
    case idr = "IDR"
    case hkd = "HKD"
    case sgd = "SGD"
    case twd = "TWD"
    case krw = "KRW"
    case thb = "THB"
    case myr = "MYR"
    case npr = "NPR"
    case php = "PHP"
    case vnd = "VND"
    case kes = "KES"
    case egp = "EGP"
    case byn = "BYN"
    case uah = "UAH"
    case kzt = "KZT"
    case tmt = "TMT"
    case czk = "CZK"
    
    var id: String {
        return self.rawValue
    }
    
    var symbol: String {
        let currencySymbols: [Currency: String] = [
            .usd: "$",
            .aed: "د.إ‎",
            .eur: "€",
            .jpy: "¥",
            .gbp: "£",
            .aud: "$",
            .cad: "$",
            .chf: "CHF",
            .cny: "¥",
            .rub: "₽",
            .inr: "₹",
            .brl: "R$",
            .zar: "R",
            .TRY: "₺",
            .mxn: "$",
            .npr: "रु",
            .idr: "Rp",
            .hkd: "HK$",
            .sgd: "S$",
            .twd: "NT$",
            .krw: "₩",
            .thb: "฿",
            .myr: "RM",
            .php: "₱",
            .vnd: "₫",
            .kes: "KSh",
            .egp: "£",
            .byn: "Br",
            .uah: "₴",
            .kzt: "₸",
            .tmt: "m",
            .czk: "Kč"
        ]
        return currencySymbols[self] ?? ""
    }
    
    static var sortedCases: [Currency] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }
}
