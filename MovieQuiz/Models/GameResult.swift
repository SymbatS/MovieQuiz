import UIKit

struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    
    func isBetter(_ that: GameResult) -> Bool {
        correct > that.correct
    }
}
