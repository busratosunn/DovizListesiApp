//
//  CustomFavoritesTableViewCell.swift
//  Döviz App 2
//
//  Created by Gülhan Büşra TOSUN on 12.03.2025.
//

import UIKit
// bu sayfada favori sayfamızdaki view ları tanımladığımız bağlantılarını yaptığımız sayfa.

class CustomFavoritesTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var isFavorite = false
    var indexPath: IndexPath?
    //weak var delegate: CustomFavoritesTableViewCellDelegate?
    
    override func awakeFromNib() { // storyboard üzerinden yüklenen hücrenin ilk yarlarının yapıldığı yer.
        super.awakeFromNib() // üsteki sınıfın başlangıç işlemlerini yapmasını sağlar. hücre ilk açıldığında yapılacak bir işlem yoksa parantez içi boş kalır ama genelde burada görsel ayarları tıklama hareketleri filan yapılır.
        // Initialization code
    }
    
    func setupGesture(){
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavoriteTap))
        favoriteImageView.isUserInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(favoriteTapGesture)
    }

    @objc func handleFavoriteTap() {
        isFavorite.toggle()
        let favoriteIconName = isFavorite ? "selectedFav" : "nonSelectedFav"
        favoriteImageView.image = UIImage(named: favoriteIconName)

        guard let currencyIdentifier = nameLabel.text else { return }

        var favoriteItems = UserDefaults.standard.array(forKey: "favoriteCurrencies") as? [String] ?? []

        if isFavorite {
            if !favoriteItems.contains(currencyIdentifier) {
                favoriteItems.append(currencyIdentifier)
            }
        } else {
            favoriteItems.removeAll { $0 == currencyIdentifier }
        }
        
        UserDefaults.standard.setValue(favoriteItems, forKey: "favoriteCurrencies")
        

        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
        
    }
