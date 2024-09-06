import Foundation

final class StatisticService {
    
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correct
        case total
        case gamesCount
        case bestGame
        case bestGameCorrect
        case bestGameTotal
    }
}

extension StatisticService: StatisticServiceProtocol {
    var correct: Int {
        get {
            let currentCorrect = storage.integer(forKey: Keys.correct.rawValue)
            return currentCorrect
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get  {
            let currentTotal = storage.integer(forKey: Keys.total.rawValue)
            return currentTotal
        }
        set {
            storage.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            let currentGamesCount = storage.integer(forKey: Keys.gamesCount.rawValue)
            return currentGamesCount
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let bestGameCorrect = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let bestGameTotal = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGame.rawValue) as? Date ?? Date()
            let result = GameResult(correct: bestGameCorrect, total: bestGameTotal, date: date)
            return result
        }
        set {
            storage.set(newValue, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard total > 0 else {return 0.0}
        return (Double(correct) / Double(total)) * 100.0
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correct += count
        total += amount
        
        let currentBestGame = bestGame
        let newResult = GameResult(correct: count, total: amount, date: Date())
        
        if newResult.correct > currentBestGame.correct {
            storage.set(newResult.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newResult.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newResult.date, forKey: Keys.bestGame.rawValue)
        }
    }
}

