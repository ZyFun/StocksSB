//
//  StockListViewController.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

import UIKit

class StockListViewController: UITableViewController {
    
    // MARK: - Private properties
    private var stocks: [Stock] = []
    private var activityIndicator = UIActivityIndicatorView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        setActivityIndicator(in: tableView, for: &activityIndicator)
        
        getStocks()
        
        // TODO: Добавить обновления данных свайпом таблицы вниз.
        // TODO: Добавить алерт контроллер с кнопкой обновления данных при отсутствии сети или отменой с остановкой анимации индикатора.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stocks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell

        let stock = stocks[indexPath.row]
        cell.configure(with: stock)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - Private method
extension StockListViewController {
    // TODO: Вывести алерт при отсутствии сети
    private func getStocks() {
        // TODO: Убрать ключь в отдельный безопасный файл и добавить его в гит игнор (добавить в проект гитигнор) В дальнейшем делать так со всеми ключами. Данный токен уничтожить и сгенерировать новый. Почитать подробнее о том, как хранить токены.
        let token = "pk_92287e65be054541b0a167b0ac4fa0aa"
        
        activityIndicator.startAnimating()
        
        // TODO: Сделать так, чтобы при отсутствии интернета, цикл завершался
        DataManager.shared.companySymbols.forEach { symbol in
            let stockUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)"
            
            NetworkDataFetcher.shared.fetch(dataType: Stock.self, urlString: stockUrlString) { [weak self] stock in
                self?.stocks.append(stock)
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setActivityIndicator(in view: UIView, for activityIndicator: inout UIActivityIndicatorView){
        
        //        activityIndicator.center = view.center // тоже самое что и ручная настройка, но без фрейма
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50,
                                                                  y: view.frame.height / 2 - 150,
                                                                  width: 100, height: 100))
        activityIndicator.backgroundColor = .systemGray4
        activityIndicator.layer.cornerRadius = 15
        activityIndicator.style = .large
        activityIndicator.color = .black // цвет установлен для того, чтобы при применении прозрачности, индикатор оставался насыщенным
        activityIndicator.alpha = 0.5

        view.addSubview(activityIndicator)
    }
}
