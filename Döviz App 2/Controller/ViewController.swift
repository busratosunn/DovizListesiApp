//
//  ViewController.swift
//  Döviz App 2
//
//  Created by Gülhan Büşra TOSUN on 4.03.2025.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceSortImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var isSorting = true
        var currencies: [Currency] = []


    override func viewDidLoad() { // view yüklendiğinde çalışacak kod bloğu.
        super.viewDidLoad()
        currencies = loadCurriencies()
        tableView.reloadData()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sortCurriencies))
            priceSortImage.isUserInteractionEnabled = true
            priceSortImage.addGestureRecognizer(tapGesture)
        
       

    }
    func loadCurriencies() -> [Currency] {
        if let url = Bundle.main.url(forResource: "currencies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let currencyList = try JSONDecoder().decode(CurrencyList.self, from: data)
                return currencyList.currencies // currencyList.currencies ile dövizleri alıyoruz
            } catch {
                print("JSON parse hatası: \(error)")
            }
        } else {
            print("JSON dosyası bulunamadı.")
        }
        return []
    }


    @objc func sortCurriencies(){
        func extractNumericValue(from price: String) -> Double {
                    let cleanedString = price.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
                    return Double(cleanedString) ?? 0.0
                }
         
                currencies.sort {
                    let first = extractNumericValue(from: $0.lastValue)
                    let second = extractNumericValue(from: $1.lastValue)
                    return isSorting ? (first < second) : (first > second)
                }
                
                isSorting.toggle()
        
        let priceSortingIconName = isSorting ? "arrowDown" : "arrowUp"
        priceSortImage.image = UIImage(named: priceSortingIconName)
                tableView.reloadData()
    }
    
    @objc func favoritesUpdated() {
        let favoriteIds = UserDefaults.standard.array(forKey: "favoriteCurrencies") as? [String] ?? []
        
        for (index, currency) in currencies.enumerated() {
            let isFavorite = favoriteIds.contains(currency.name)
            currencies[index].isFavorite = isFavorite
        }
        
        tableView.reloadData()
    }

    
}
    

extension ViewController: UITableViewDelegate { //Hücrelerin boyutunu, seçimini vb. yönetmek için kullanılır.
  
    
}

extension ViewController: UITableViewDataSource { // Hücreleri ve içeriğini yönetmek için kullanılıyor.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell // storyboardda hücreye verilen isim cell olduğu için onu yazıyoruz. ve hücreyi customviewcell sınıfına dönüştürüyoruz.(bizim nesnemiz UITableView ama biz onu CustomViewCelle dönüştürüyoruz.) as! kullanmamızın sebebi ben bunun böyle olduğunu biliyorum ve buna eminim anlamında kullanıyoruz.
        let currency = currencies[indexPath.row]
        print(type(of: currencies[indexPath.row].logo)) // hücrenin sırasını belirtiyor.(indexpath.row) ve logonun veri tipini görmek için ekrana yazdırıyoruz.
        cell.nameLabel.text = currencies[indexPath.row].name // hücredeki her eleman currencies elemanıyla dolduruluyor.
        cell.iconImageView.image = UIImage(named: currencies[indexPath.row].logo ?? "")
        cell.priceLabel.text = currencies[indexPath.row].lastValue
        cell.percentLabel.text = currencies[indexPath.row].change
        let favoriteItems = UserDefaults.standard.array(forKey: "favoriteCurrencies") as? [String] ?? []
        
        let isFavorite = favoriteItems.contains(currency.name)
        cell.favoriteImageView.image = UIImage(named: isFavorite ? "selectedFav" : "nonSelectedFav")
       
        if let changeValue = Double(currency.change.replacingOccurrences(of: "%", with: "")) {
            if changeValue > 0 {
                cell.backgroundColor = UIColor.green.withAlphaComponent(0.2) // Artış -> Yeşil
            } else if changeValue < 0 {
                cell.backgroundColor = UIColor.red.withAlphaComponent(0.2) // Azalış -> Kırmızı
            } else {
                cell.backgroundColor = UIColor.white // Değişim yoksa Beyaz
            }
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // logoya tıklama özelliği verdik.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Bu satırda, uygulamanın ana storyboard'u (genellikle "Main" olarak adlandırılır) yüklendiği bir UIStoryboard nesnesi oluşturuluyor. Bu storyboard'da yer alan tüm view controller'lara (görünüm denetleyicileri) erişilebilir.bundle: nil parametresi, storyboard'un ana bundle'dan (uygulamanın derleme dosyalarından) yüklenmesini sağlar.
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "CurrencyDetailViewController") as? CurrencyDetailViewController { //instantiateViewController(withIdentifier:) metodu, storyboard'dan belirli bir view controller'ı almak için kullanılır ve bu metot, bir optional döner. Bu yüzden if let kullanılarak güvenli bir şekilde unwrap edilmiştir.Eğer CurrencyDetailViewController başarıyla storyboard'dan yüklendiyse, bu controller detailVC değişkenine atanır ve işlemler devam eder.
            let selectedCurrency = currencies[indexPath.row] // seçilen dövizi belli eder.
            detailVC.currencyLogo = UIImage(named: selectedCurrency.logo ?? "")
            detailVC.currencyName = selectedCurrency.change
            detailVC.currencyPrice = selectedCurrency.lastValue
            navigationController?.pushViewController(detailVC, animated: true) // Son olarak, navigationController?.pushViewController() metodu çağrılır. Bu metod, detailVC'yi (CurrencyDetailViewController) navigasyon yığınındaki bir sonraki view controller olarak ekler.
            //animated: true parametresi, geçişin animasyonlu bir şekilde gerçekleşmesini sağlar.
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // numberOfRowsInSection: Tablo kaç hücre göstereceğini belirtiyor. girişimiz bir int olucak ve bizden istenen değer de int değer olucak.
        return currencies.count // dönüşümüz ise currencies arrayinin içindeki değerlerin sayısı.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // ve hücreye belli bir yüseklik verdik.
        return 120 // Hücre yüksekliği (ihtiyaca göre artırılabilir)
    }
}


