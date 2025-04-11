//
//  CurrencyDetailViewController.swift
//  Döviz App 2
//
//  Created by Gülhan Büşra TOSUN on 6.03.2025.
//

import UIKit
// BU sayfa anasayfadaki dövizlerin detaylarını içeren sayfamızın kodları.
class CurrencyDetailViewController: UIViewController { // CurrencyDetailViewController sınıfı tanımladık ve UIViewController dan miras almasını istedik.

    
    @IBOutlet weak var priceLabel: UILabel! // bağlantılarını da yaptık.
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
// dövizin logosunu ismini ve fiyatını tutuyor.
    var currencyLogo: UIImage?
    var currencyName: String?
    var currencyPrice: String?
   
    
    override func viewDidLoad() { //  Yani ekran kullanıcıya gösterilmeden önce yapılması gereken işlemleri burada yapıyoruz.
        super.viewDidLoad() // Bu ifade de UIViewController sınıfının kendi ViewDidLoad metodunu çağırmasını sağlıyor. Bu satırda temel yapılandırmaları yapıyoruz.Sayfaya eklediğimiz viewların düzgün gözükmesini sağlar.
        logoImageView.image = currencyLogo // Logoyu ekranda bir UIImage içinde göstermeye yarar.
        percentLabel.text = currencyName // dövizin adını gösterdiğimiz kısım.
        priceLabel.text = currencyPrice // Dövizin fiyatını gösterdiğimiz kısım.
        priceLabel.numberOfLines = 0 // Sınırsız satır
        priceLabel.lineBreakMode = .byWordWrapping // Kelime bazında kaydırma
        priceLabel.adjustsFontSizeToFitWidth = false // Yazı boyutunu küçültme
        priceLabel.sizeToFit() // Label’ı içeriğe göre boyutlandır
}


}
