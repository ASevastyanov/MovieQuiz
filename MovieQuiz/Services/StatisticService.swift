import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func saveResultRecord(correct count: Int, total amount: Int)
}

//MARK: Класс по подсчету статистики и хранению
final class StatisticServiceImplementation: StatisticService {
    
    // MARK: - Propeties
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    //MARK: - init
    init(
        userDefaults: UserDefaults = .standard,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
    
    // MARK: - Propeties
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? decoder.decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        set {
            guard let data = try? encoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    //MARK: - Func
    func saveResultRecord(correct: Int, total: Int) {
        self.gamesCount += 1
        self.total += total
        self.correct += correct
        
        let date = dateProvider()
        let currentBestGame = GameRecord(correct: correct, total: total, date: date)
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            } else {
                bestGame = previousBestGame
            }
        }
    }
}

