import Foundation

final class StatisticService {
    
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount
        case bestGame
        case total
        case correct
    }
}



extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            let currentGamesCount = storage.integer(forKey: Keys.gamesCount.rawValue)
            let newGamesCount = currentGamesCount + 1
            return newGamesCount
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.bestGame.rawValue) as? Date ?? Date()
            let result = GameResult(correct: correct, total: total, date: date)
            return result
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
            storage.set(newValue, forKey: Keys.total.rawValue)
            storage.set(newValue, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        return (Double(bestGame.correct)/(10.0 * Double(bestGame.total))) * 100.0
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        let currentBestGame = bestGame
        let newResult = GameResult(correct: count, total: amount, date: Date())
        
        if (Double(newResult.correct) / Double(newResult.total)) > (Double(currentBestGame.correct) / Double(currentBestGame.total)) {
            // Устанавливаем новый рекорд
            storage.set(newResult.correct, forKey: Keys.correct.rawValue)
            storage.set(newResult.total, forKey: Keys.total.rawValue)
            storage.set(newResult.date, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
}

