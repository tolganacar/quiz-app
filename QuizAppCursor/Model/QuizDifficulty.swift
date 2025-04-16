enum QuizDifficulty: String, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    case any = ""
    
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .any: return "Any Difficulty"
        }
    }
    
    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "yellow"
        case .hard: return "red"
        case .any: return "blue"
        }
    }
    
    var emoji: String {
        switch self {
        case .easy: return "😊"
        case .medium: return "😐"
        case .hard: return "😰"
        case .any: return "🔄"
        }
    }
} 