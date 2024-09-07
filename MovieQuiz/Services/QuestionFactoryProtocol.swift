import UIKit

protocol QuestionFactoryProtocol {
    var questions: [QuizQuestion] {get}
    func setup(delegate: QuestionFactoryDelegate)
    func requestNextQuestion()
}
