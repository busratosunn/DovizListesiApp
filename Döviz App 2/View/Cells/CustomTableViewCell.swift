//
//  CustomTableViewCell.swift
//  Döviz App 2
//
//  Created by Gülhan Büşra TOSUN on 4.03.2025.
//

import UIKit
// Bu kod satırı dövizleri listelediğimiz UITableView içinde her bir döviz için hücre oluşturmak favorileme işini yönetmek için kullanılır.
class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
//    //func setupCell(name: String, price: String, percentChange: String) {
//            nameLabel.text = name
//            priceLabel.text = price
//            percentLabel.text = percentChange
//        }awa
//
    var isFavorite = false // favori hücresini başta favori değil olarak tanımladık.
    var indexPath: IndexPath? // hücrenin tablo içindeki konumunu saklamak için kullanılır.
    
    override func awakeFromNib() { // hücrenin ilk oluştuğunda yapılacak işleri temsil eder.
        super.awakeFromNib() // üst sınıfın kendi ayarlarını yapması için kullanılır.
        setupGesture() // favori image'ne tıklamak için kullanılır.
        // Initialization code
    }
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped)) // UITapGestureRecognizer ekrana tıklama hareketlerini algılamak için kullanılır.target ise hangi nesneyi ele alacağını belirtiyor self dememiz bu hücreyi al diyoruz.selector ise hangi fonksiyonu kullanacağımızı söylüyor.
        favoriteImageView.isUserInteractionEnabled = true // image normalde tıklanmaz bunu tıklanabilir hale getirmek için true parametresi atıyoruz.
        favoriteImageView.addGestureRecognizer(tapGesture) // favori ikonuna tıklama hareketini bağlıyor.
    }
    
    
    @objc func favoriteTapped() {
        isFavorite.toggle()
        let imageName = isFavorite ? "selectedFav" : "nonSelectedFav"
        favoriteImageView.image = UIImage(named: imageName)
        
                guard let currencyId = nameLabel.text else { return } // Dövizin adını alıyoruz.
        
                var favorites = UserDefaults.standard.array(forKey: "favoriteCurrencies") as? [String] ?? []
        
                if isFavorite {
                    if
                        !favorites.contains(currencyId) {
                        favorites.append(currencyId) // Favoriye ekle
                    }
                } else {
                    favorites.removeAll { $0 == currencyId } // Favoriden çıkar
                }
        
                UserDefaults.standard.setValue(favorites, forKey: "favoriteCurrencies") // Güncellenmiş listeyi kaydet
                NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
            }
        
    }
