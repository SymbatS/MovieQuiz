import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject, AlertPresenterDelegate {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func changeStateButton(isEnabled: Bool)
    
    func presentAlert(_ alert: UIAlertController)
}
