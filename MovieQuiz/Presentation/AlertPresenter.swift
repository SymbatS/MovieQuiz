import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    func setup(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    func showAlertResult(_ model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            model.completion()
        }
        alert.view.accessibilityIdentifier = "Alert"
        alert.addAction(action)
        delegate?.presentAlert(alert)
    }
}
