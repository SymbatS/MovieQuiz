import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    
    func isBetter(_ that: GameResult) -> Bool {
        correct > that.correct
    }
}
