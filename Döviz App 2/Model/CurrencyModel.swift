//
//  CurrencyModel.swift
//  Döviz App 2
//
//  Created by Gülhan Büşra TOSUN on 12.03.2025.
//
// Bu sayfa mvc oluşturduğumuz sayfa. Projelerimiz daha düzenli olsun diye bunu yapıyoruz.mvc : modelViewController.
import Foundation
import UIKit

struct CurrencyList: Codable {
    let currencies: [Currency]
}

struct Currency: Codable { // dövizin özelliklerini bir struct içinde tanımlıyoruz. adı da currency.
    var id : String
    var logo: String? // Asset Image Name
    var name: String
    var lastValue: String
    var change: String
    var isFavorite: Bool
}

