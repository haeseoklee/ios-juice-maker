//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class JuiceOrderViewController: UIViewController {
    @IBOutlet private weak var strawberryStockLabel: UILabel!
    @IBOutlet private weak var bananaStockLabel: UILabel!
    @IBOutlet private weak var pineappleStockLabel: UILabel!
    @IBOutlet private weak var kiwiStockLabel: UILabel!
    @IBOutlet private weak var mangoStockLabel: UILabel!
    
    @IBOutlet private weak var strawberryBananaJuiceOrderButton: UIButton!
    @IBOutlet private weak var mangoKiwiJuiceOrderButton: UIButton!
    @IBOutlet private weak var strawberryJuiceOrderButton: UIButton!
    @IBOutlet private weak var bananaJuiceOrderButton: UIButton!
    @IBOutlet private weak var pineappleJuiceOrderButton: UIButton!
    @IBOutlet private weak var kiwiJuiceOrderButton: UIButton!
    @IBOutlet private weak var mangoJuiceOrderButton: UIButton!
    
    private let juiceMaker: JuiceMaking = JuiceMaker(store: FruitStore())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFruitStockLabels()
        NotificationCenter.default.addObserver(self, selector: #selector(didFruitStockChange(_:)), name: .FruitStockChanged, object: nil)
    }
    
    @IBAction private func juiceOrderButtonDidTap(_ sender: UIButton) {
        do {
            let juiceMenu = try matchJuiceMenu(with: sender)
            try juiceMaker.makeJuice(menu: juiceMenu)
            showSuccessAlert(juiceMenu: juiceMenu)
        } catch FruitStoreError.stockShortage {
            showFailureAlert()
        } catch let error {
            showErrorAlert(error: error)
        }
    }

    @IBAction private func modifyStockButtonDidTap(_ sender: UIBarButtonItem) {
        moveToStockModifyView()
    }
    
    @objc private func didFruitStockChange(_ notification: Notification) {
        guard let fruit = notification.object as? Fruit else {
            showErrorAlert(error: FruitStoreError.invalidFruit)
            return
        }
        do{
            try updateLabel(fruit: fruit)
        } catch let error {
            showErrorAlert(error: error)
        }
    }
    
    private func updateLabel(fruit: Fruit) throws {
        switch fruit {
        case .strawberry:
            strawberryStockLabel.text = String(try juiceMaker.currentFruitStock(of: .strawberry))
        case .banana:
            bananaStockLabel.text = String(try juiceMaker.currentFruitStock(of: .banana))
        case .pineapple:
            pineappleStockLabel.text = String(try juiceMaker.currentFruitStock(of: .pineapple))
        case .kiwi:
            kiwiStockLabel.text = String(try juiceMaker.currentFruitStock(of: .kiwi))
        case .mango:
            mangoStockLabel.text = String(try juiceMaker.currentFruitStock(of: .mango))
        }
    }
    
    private func initializeFruitStockLabels() {
        do {
            strawberryStockLabel.text = String(try juiceMaker.currentFruitStock(of: .strawberry))
            bananaStockLabel.text = String(try juiceMaker.currentFruitStock(of: .banana))
            pineappleStockLabel.text = String(try juiceMaker.currentFruitStock(of: .pineapple))
            kiwiStockLabel.text = String(try juiceMaker.currentFruitStock(of: .kiwi))
            mangoStockLabel.text = String(try juiceMaker.currentFruitStock(of: .mango))
        } catch let error {
            showErrorAlert(error: error)
        }
    }
    
    private func matchJuiceMenu(with button: UIButton) throws -> JuiceMenu {
        if button === strawberryBananaJuiceOrderButton {
            return .strawberryBanana
        } else if button === mangoKiwiJuiceOrderButton {
            return .mangoKiwi
        } else if button === strawberryJuiceOrderButton {
            return .strawberry
        } else if button === bananaJuiceOrderButton {
            return .banana
        } else if button === pineappleJuiceOrderButton {
            return .pineapple
        } else if button === kiwiJuiceOrderButton {
            return .kiwi
        } else if button === mangoJuiceOrderButton {
            return .mango
        } else {
            throw JuiceOrderError.invalidJuiceOrder
        }
    }
    
    private func showSuccessAlert(juiceMenu: JuiceMenu) {
        let alert = UIAlertController(title: nil, message: juiceMenu.rawValue + AlertMessage.juiceMakeSuccess.korean, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessage.ok.korean, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showFailureAlert() {
        let alert = UIAlertController(title: nil, message: FruitStoreError.stockShortage.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessage.modifyStock.korean, style: .default) { _ in self.moveToStockModifyView() }
        let cancelAction = UIAlertAction(title: AlertMessage.cancel.korean, style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessage.ok.korean, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.toStockModifyView.identifier {
            guard let stockModifyViewNavigationController = segue.destination as? UINavigationController else {
                return
            }
            guard let stockModifyViewController = stockModifyViewNavigationController.visibleViewController as? StockModifyViewController else {
                return
            }
            stockModifyViewController.juiceMaker = self.juiceMaker
        }
    }
    
    private func moveToStockModifyView() {
        performSegue(withIdentifier: StoryboardSegue.toStockModifyView.identifier, sender: nil)
    }
}
