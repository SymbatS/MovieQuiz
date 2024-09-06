import UIKit

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    var correct: Int { get }
    var total: Int { get }
    func store(correct count: Int, total amount: Int)
}
