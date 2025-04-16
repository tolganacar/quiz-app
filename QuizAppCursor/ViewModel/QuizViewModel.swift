import Foundation

class QuizViewModel {
    // MARK: - Properties
    private var quiz: Quiz
    private var currentQuestionIndex = 0
    private var score = 0
    
    // MARK: - Observable Properties
    var onQuestionChange: ((Question) -> Void)?
    var onScoreUpdate: ((Int, Int) -> Void)?
    var onQuizComplete: ((Int, Int) -> Void)?
    var onAnswerSelected: ((Int, Bool) -> Void)?
    
    // MARK: - Computed Properties
    var currentQuestion: Question {
        return quiz.questions[currentQuestionIndex]
    }
    
    var questionCount: Int {
        return quiz.questions.count
    }
    
    var progress: Float {
        return Float(currentQuestionIndex) / Float(quiz.questions.count)
    }
    
    var title: String {
        return quiz.title
    }
    
    // MARK: - Initialization
    init(quiz: Quiz) {
        self.quiz = quiz
        if !quiz.questions.isEmpty {
            onQuestionChange?(currentQuestion)
        }
    }
    
    // MARK: - Methods
    func selectAnswer(at index: Int) {
        let isCorrect = index == currentQuestion.correctAnswerIndex
        
        if isCorrect {
            score += 1
        }
        
        onScoreUpdate?(score, questionCount)
        
        // Notify that an answer was selected
        onAnswerSelected?(currentQuestion.correctAnswerIndex, isCorrect)
        
        // Move to the next question will be called from the view controller after showing the feedback
    }
    
    func moveToNextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < quiz.questions.count {
            onQuestionChange?(currentQuestion)
        } else {
            onQuizComplete?(score, questionCount)
        }
    }
    
    func restart() {
        currentQuestionIndex = 0
        score = 0
        
        if !quiz.questions.isEmpty {
            onQuestionChange?(currentQuestion)
        }
        
        onScoreUpdate?(score, questionCount)
    }
} 