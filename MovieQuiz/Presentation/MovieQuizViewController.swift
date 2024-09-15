import UIKit
final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {

    // MARK: - IB Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Public Properties
    var alertPresenter: AlertPresenterProtocol = AlertPresenter()

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter.setup(delegate: self)
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - IBActions

    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    // MARK: - Public Methods
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
            
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
            alertPresenter.showAlertResult(model)
    }
    
    func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}

