import Foundation

struct Quiz {
    let title: String
    let questions: [Question]
}

struct Question {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
} 