enum QuizCategory: String, CaseIterable {
    case general = "General Knowledge"
    case books = "Books"
    case film = "Film"
    case music = "Music"
    case scienceNature = "Science & Nature"
    case computers = "Computers"
    case sports = "Sports"
    case history = "History"
    case animals = "Animals"
    case science = "Science"
    case geography = "Geography"
    case art = "Art"
    
    var name: String {
        return self.rawValue
    }
    
    var id: Int {
        switch self {
        case .general: return 9
        case .books: return 10
        case .film: return 11
        case .music: return 12
        case .scienceNature: return 17
        case .computers: return 18
        case .sports: return 21
        case .history: return 23
        case .animals: return 27
        case .science: return 17
        case .geography: return 22
        case .art: return 25
        }
    }
    
    var emoji: String {
        switch self {
        case .general: return "🧠"
        case .books: return "📚"
        case .film: return "🎬"
        case .music: return "🎵"
        case .computers: return "💻"
        case .sports: return "⚽️"
        case .history: return "🏛️"
        case .scienceNature: return "🔬"
        case .animals: return "🐾"
        case .science: return "🔬"
        case .geography: return "🌎"
        case .art: return "🎨"
        }
    }
} 