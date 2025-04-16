import Foundation

// Enum declarations removed as they are already defined in separate files

class QuizAPIService {
    // MARK: - Properties
    private let baseURL = "https://opentdb.com/api.php"
    
    // MARK: - Public Methods
    func fetchQuizQuestions(amount: Int = 10, 
                           category: QuizCategory? = nil, 
                           difficulty: QuizDifficulty = .any,
                           completion: @escaping (Result<Quiz, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem(name: "amount", value: "\(amount)"),
                         URLQueryItem(name: "type", value: "multiple")]
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: "\(category.id)"))
        }
        
        if difficulty != .any {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty.rawValue))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "QuizApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "QuizApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TriviaResponse.self, from: data)
                
                let title = category?.name ?? "Mixed Questions"
                let questions = response.results.map { result in
                    // Combine correct and incorrect answers
                    var options = result.incorrect_answers
                    options.append(result.correct_answer)
                    // Shuffle the options to randomize position of correct answer
                    options.shuffle()
                    
                    // Find the index of correct answer in shuffled array
                    let correctAnswerIndex = options.firstIndex(of: result.correct_answer) ?? 0
                    
                    // Create and return the Question
                    return Question(
                        text: self.decodeHTMLEntities(result.question),
                        options: options.map { self.decodeHTMLEntities($0) },
                        correctAnswerIndex: correctAnswerIndex
                    )
                }
                
                let quiz = Quiz(title: title, questions: questions)
                
                DispatchQueue.main.async {
                    completion(.success(quiz))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Helper Methods
    
    // Method to decode HTML entities in the text (like &quot;)
    private func decodeHTMLEntities(_ text: String) -> String {
        guard let data = text.data(using: .utf8) else { return text }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        
        return text
    }
}

// MARK: - API Response Models
struct TriviaResponse: Decodable {
    let response_code: Int
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
} 