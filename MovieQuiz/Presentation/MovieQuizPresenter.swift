import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Private Properties
    private let statisticService: StatisticServiceProtocol!
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Initializers
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Public Methods
    func presentAlert(_ alert: AlertModel) {
        viewController?.alertPresenter.showAlertResult(alert)
    }
    
    func noButtonClicked() {
        proceedWithAnswer(isCorrectAnswer: false)
    }
    
    func yesButtonClicked() {
        proceedWithAnswer(isCorrectAnswer: true)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    // MARK: - Private Methods
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func proceedWithAnswer(isCorrectAnswer: Bool) {
            guard let currentQuestion = currentQuestion else { return }
            viewController?.changeStateButton(isEnabled: false)

            let isAnswerCorrect = (isCorrectAnswer == currentQuestion.correctAnswer)
            if isAnswerCorrect {
                correctAnswers += 1
            }

            viewController?.highlightImageBorder(isCorrectAnswer: isAnswerCorrect)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.viewController?.changeStateButton(isEnabled: true)
                self?.proceedToNextQuestionOrResults()
            }
        }
}
