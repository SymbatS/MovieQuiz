import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func setup(delegate: AlertPresenterDelegate)
    func showAlertResult(_ model:AlertModel)
}
