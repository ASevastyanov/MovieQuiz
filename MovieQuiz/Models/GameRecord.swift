import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
} 

extension GameRecord: Comparable {
    private var accuracy: Double {
        guard total == 0 else {
            return 0
        }
        print("результат не записался")
        return Double(correct) / Double(total)
    }
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
