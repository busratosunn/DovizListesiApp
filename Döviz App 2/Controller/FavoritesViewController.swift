//
//  FavoritesViewController.swift
//  Döviz App 2
//
//  Created by Gülhan Büşra TOSUN on 10.03.2025.
//

import UIKit
// favoriler sayfasındaki dövizleri listelemek için kullandığımız sayfa.
class FavoritesViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    var favoriteCurrencies: [Currency] = [] // favorilere eklenmiş dövizlerin tutulduğu bir dizi tanımlıyoruz.başta verilerimiz olmadığı için diziyi boş tanımlıyoruz.
   
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self // hücredeki viewlara tıklama özelliği vereceğimiz için bu işlemleri yönetmek için FavoritesViewController'ı yetkili yapıyoruz.
            tableView.dataSource = self //hücrenin içini doldurmak için FavoritesViewController'ı veri kaynağı olarak kullanır..
            loadFavorites() // favori dövizleri yükleyen foksiyonu çağırır.
            tableView.reloadData() // yüklenen verileri tabloya koyar.
            
            NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        }
    
    @objc func favoritesUpdated() {
        loadFavorites()
        tableView.reloadData()
    }
        
    func loadFavorites() {
        let favoriteIds = UserDefaults.standard.array(forKey: "favoriteCurrencies") as? [String] ?? []
        
        // ViewController içindeki currencies dizisine erişim
        if let viewController = tabBarController?.viewControllers?.first(where: { $0 is ViewController }) as? ViewController {
            let allCurrencies = viewController.currencies
            favoriteCurrencies = allCurrencies.filter { favoriteIds.contains($0.name) }
        }
    }


    }

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // numberOfRowsInSection tabloda kaç satır oluşturacağını belirtir verilere göre hücre sayısını belirler.
        return favoriteCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // hücrenin içini dolduruyoruz burda da .
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! CustomFavoritesTableViewCell // dequeueReusableCell: Tablo hücresini yeniden kullanmak için belirli bir hücreyi döndürüyor. favoritesCell: Storyboard’da hücreye verilen identifier.
        let currency = favoriteCurrencies[indexPath.row] //currency: O sıradaki döviz verisini alıyor.
        cell.nameLabel.text = currency.name
        cell.iconImageView.image = UIImage(named: currency.logo ?? "") 
        cell.priceLabel.text = currency.lastValue
        cell.percentLabel.text = currency.change
        let favoriteItems = UserDefaults.standard.array(forKey: "favoriteCurrencies") as? [String] ?? []
        let isFavorite = favoriteItems.contains(currency.name)
         
         cell.isFavorite = isFavorite
         cell.favoriteImageView.image = UIImage(named: isFavorite ? "selectedFav" : "nonSelectedFav")
        
        if let changeValue = Double(currency.change.replacingOccurrences(of: "%", with: "")) {
                if changeValue > 0 {
                    cell.backgroundColor = UIColor.green.withAlphaComponent(0.2) // Artış -> Yeşil
                } else if changeValue < 0 {
                    cell.backgroundColor = UIColor.red.withAlphaComponent(0.2) // Azalış -> Kırmızı
                } else {
                    cell.backgroundColor = UIColor.white // Değişim yoksa Beyaz
                }
            }
    
        return cell
    }
}



    

 
