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
    private var activityIndicator = UIActivityIndicatorView() // Срабатывает только при старте приложения

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defaults setting
        tableView.rowHeight = 150
        setupRefreshControl()
        
        setActivityIndicator(in: tableView, for: &activityIndicator)
        
        // Network requests
        activityIndicator.startAnimating()
        getStocks()
        
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
    @objc private func getStocks() {
        // TODO: Убрать ключь в отдельный безопасный файл и добавить его в гит игнор (добавить в проект гитигнор) В дальнейшем делать так со всеми ключами. Данный токен уничтожить и сгенерировать новый. Почитать подробнее о том, как хранить токены.
        let token = "pk_92287e65be054541b0a167b0ac4fa0aa"
        
        // TODO: Сделать так, чтобы при отсутствии интернета, цикл завершался (А лучше перебирать циклом только уже закешированные данные и не начинать этот метод, если сеть отсутствует. К примеру при старте приложения делать пинг до яндекса, и если ответ не 200, прекращать выполнение работы и выводить сообщение об ошибке)
        
        title = "Gainers stocks"
        let stockUrlString = "https://cloud.iexapis.com/stable/stock/market/list/gainers%20./quote?token=\(token)"
        
        NetworkDataFetcher.shared.fetch(dataType: [Stock].self, urlString: stockUrlString) { [weak self] result in
            switch result {
            case .success(let stock):
                self?.stocks = stock // Используется для получения массива акций с сервера
                
                if stock.isEmpty {
                    // Использование заглушки, чтобы при отсутствии данных с сервера, загрузилось хоть что-то и было видно что приложение работает. Такое решение было принято, потому что при получении массива с сервера, стал приходить пустой массив
                    self?.title = "Stocks"
                    self?.showAlertReloadData(title: "Inline data loaded", message: "No data received, to retry?")
                    
                    DataManager.shared.companySymbols.forEach { symbol in
                        let hardcodeStockUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)"
                        
                        NetworkDataFetcher.shared.fetch(dataType: Stock.self, urlString: hardcodeStockUrlString) { result in
                            switch result {
                            case .success(let stock):
                                self?.stocks.append(stock)
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
                
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            case .failure(let error):
                if error == .noData {
                    self?.showAlertReloadData(title: "Network error", message: "No internet connection, to retry?")
                }
            }
            
            if self?.refreshControl != nil {
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl() // Конспект: инициализация refreshControl для его активации в интерфейсе
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading data")
        refreshControl?.addTarget(self, action: #selector(getStocks), for: .valueChanged)
    }
    
    private func setActivityIndicator(in view: UIView, for activityIndicator: inout UIActivityIndicatorView){
        
        //        activityIndicator.center = view.center // тоже самое что и ручная настройка, но без фрейма
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50,
                                                                  y: view.frame.height / 2 - 150,
                                                                  width: 100, height: 100))
        activityIndicator.backgroundColor = .systemGray4
        activityIndicator.layer.cornerRadius = 15
        activityIndicator.style = .large
        activityIndicator.color = .label // цвет установлен для того, чтобы при применении прозрачности, индикатор оставался насыщенным. А именно этот цвет, для поддержания темной темы
        activityIndicator.alpha = 0.5

        view.addSubview(activityIndicator)
    }
    
    func showAlertReloadData(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let loadAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.activityIndicator.startAnimating()
            self.getStocks()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
        
        alert.addAction(loadAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
