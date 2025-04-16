import UIKit

class QuizViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: QuizViewModel
    private var optionButtons: [UIButton] = []
    private let feedbackDelay: TimeInterval = 1.0 // Delay in seconds before moving to next question
    private let quizSource: QuizSource
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - UI Elements
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .left
        button.setTitle(" Home", for: .normal)
        button.titleLabel?.font = AppTheme.Fonts.body
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        AppTheme.Elements.styleCard(view)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.subtitle
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressTintColor = AppTheme.Colors.accent
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progress.layer.cornerRadius = 4
        progress.clipsToBounds = true
        progress.layer.sublayers![1].cornerRadius = 4
        progress.subviews[1].clipsToBounds = true
        return progress
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.subtitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initialization
    init(viewModel: QuizViewModel, quizSource: QuizSource) {
        self.viewModel = viewModel
        self.quizSource = quizSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        setupUI()
        bindViewModel()
        viewModel.restart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = AppTheme.Colors.gradient
        gradientLayer?.locations = [0.0, 1.0]
        gradientLayer?.frame = view.bounds
        
        if let gradientLayer = gradientLayer {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        
        // Add subviews
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(progressView)
        view.addSubview(containerView)
        containerView.addSubview(questionLabel)
        containerView.addSubview(optionsStackView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Score label
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Progress view
            progressView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            // Container view
            containerView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Question label
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Options stack view
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        titleLabel.text = viewModel.title
        
        // Add back button action
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onQuestionChange = { [weak self] question in
            self?.updateQuestion(question)
        }
        
        viewModel.onScoreUpdate = { [weak self] score, total in
            self?.updateScore(score, total)
        }
        
        viewModel.onQuizComplete = { [weak self] score, total in
            self?.showResults(score, total)
        }
        
        viewModel.onAnswerSelected = { [weak self] correctAnswerIndex, isCorrect in
            self?.highlightAnswers(correctAnswerIndex: correctAnswerIndex, isCorrect: isCorrect)
        }
    }
    
    // MARK: - UI Updates
    private func updateQuestion(_ question: Question) {
        // Animate the question change
        UIView.transition(with: questionLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.questionLabel.text = question.text
        })
        
        progressView.setProgress(viewModel.progress, animated: true)
        
        // Remove existing option buttons
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        optionButtons.removeAll()
        
        // Add option buttons with animation
        for (index, option) in question.options.enumerated() {
            let button = createOptionButton(title: option, index: index)
            button.alpha = 0 // Start with transparent buttons
            optionsStackView.addArrangedSubview(button)
            optionButtons.append(button)
            
            // Animate button appearance with a slight delay based on index
            UIView.animate(withDuration: 0.3, delay: 0.1 * Double(index), options: [.curveEaseOut], animations: {
                button.alpha = 1
            })
        }
    }
    
    private func updateScore(_ score: Int, _ total: Int) {
        scoreLabel.text = "Score: \(score)/\(total)"
    }
    
    private func createOptionButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = AppTheme.Fonts.body
        button.backgroundColor = .white
        button.setTitleColor(AppTheme.Colors.text, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.tag = index
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        
        // Add shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.1
        
        return button
    }
    
    private func highlightAnswers(correctAnswerIndex: Int, isCorrect: Bool) {
        // Disable all buttons to prevent further selection
        optionButtons.forEach { $0.isEnabled = false }
        
        // Get the correct button
        let correctButton = optionButtons[correctAnswerIndex]
        
        // Apply success animation to correct button
        UIView.animate(withDuration: 0.3, animations: {
            correctButton.backgroundColor = AppTheme.Colors.success
            correctButton.setTitleColor(.white, for: .normal)
            correctButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                correctButton.transform = .identity
            }
        }
        
        // If the user selected an incorrect answer, highlight it in red with shake animation
        if !isCorrect {
            // Find the selected button
            if let selectedButton = optionButtons.first(where: { $0.isHighlighted || $0.backgroundColor == AppTheme.Colors.primary }) {
                UIView.animate(withDuration: 0.3, animations: {
                    selectedButton.backgroundColor = AppTheme.Colors.error
                    selectedButton.setTitleColor(.white, for: .normal)
                })
                
                // Add shake animation for wrong answer
                let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
                animation.timingFunction = CAMediaTimingFunction(name: .linear)
                animation.duration = 0.6
                animation.values = [-8.0, 8.0, -6.0, 6.0, -4.0, 4.0, 0.0]
                selectedButton.layer.add(animation, forKey: "shake")
            }
        } else {
            // For correct answer, add a subtle pulse animation
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = 0.1
            animation.toValue = 0.4
            animation.duration = 0.5
            animation.autoreverses = true
            correctButton.layer.add(animation, forKey: "pulse")
        }
        
        // Wait for a delay before moving to the next question
        DispatchQueue.main.asyncAfter(deadline: .now() + feedbackDelay) { [weak self] in
            self?.viewModel.moveToNextQuestion()
            
            // Re-enable buttons for the next question
            self?.optionButtons.forEach { $0.isEnabled = true }
        }
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        // Highlight the selected button immediately
        UIView.animate(withDuration: 0.2) {
            sender.backgroundColor = AppTheme.Colors.primary
            sender.setTitleColor(.white, for: .normal)
        }
        
        viewModel.selectAnswer(at: sender.tag)
    }
    
    private func showResults(_ score: Int, _ total: Int) {
        let resultsVC = ResultsViewController(score: score, totalQuestions: total, quizSource: quizSource)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        // Ask for confirmation before quitting the quiz
        let alertController = UIAlertController(
            title: "Exit Quiz?",
            message: "Are you sure you want to return to the home screen? Your progress will be lost.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let quitAction = UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            // Navigate back to welcome screen
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(quitAction)
        present(alertController, animated: true)
    }
} 