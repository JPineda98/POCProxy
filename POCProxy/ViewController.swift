//
//  ViewController.swift
//  POCProxy
//
//  Created by Javier Pineda Gonzalez on 23/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var urlLabel: UILabel!
    
    var items: [ItemModel] = [ItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
    }

    @IBAction func makeMockCall(_ sender: UIButton) {
        urlLabel.text = mockUrl
        makeApiCall(isNormalCall: false)
    }
    
    @IBAction func makeNormalCall(_ sender: UIButton) {
        urlLabel.text = mainUrl
        makeApiCall(isNormalCall: true)
    }
    
    private func makeApiCall(isNormalCall: Bool) {
        guard let url = URL(string: isNormalCall ? mainUrl : mockUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                if let drinks = try? JSONDecoder().decode(DrinksModel.self, from: data) {
                    self?.items = drinks.drinks
                    DispatchQueue.main.async {
                        self?.itemTableView.reloadData()
                    }
                } else {
                    print("Ocurrio un problema al serializar los datos")
                }
            } else {
                guard let error = error else { return }
                print("La llamada al API fallo \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = items[indexPath.row]
        var listConfiguration = UIListContentConfiguration.cell()
        listConfiguration.text = item.title
        cell.contentConfiguration = listConfiguration
        return cell
    }
}
