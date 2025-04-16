import UIKit

enum QuizSource {
    case online(category: QuizCategory?, difficulty: QuizDifficulty)
}

class ResultsViewController: UIViewController {
    // MARK: - Properties
    private let score: Int
    private let totalQuestions: Int
    private let quizSource: QuizSource
    private let apiService = QuizAPIService()
    private var gradientLayer: CAGradientLayer?
    private var confettiLayer: CAEmitterLayer?
    
    // MARK: - UI Elements
    private let homeButtonTop: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "house"), for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .left
        button.setTitle(" Home", for: .normal)
        button.titleLabel?.font = AppTheme.Fonts.body
        return button
    }()
    
    private let resultsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        AppTheme.Elements.styleCard(view)
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.largeTitle
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.title
        label.textAlignment = .center
        label.text = "Results"
        label.textColor = .white
        return label
    }()
    
    private let feedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.subtitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.title
        label.textAlignment = .center
        return label
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play Again", for: .normal)
        AppTheme.Elements.styleButton(button, withBackgroundColor: AppTheme.Colors.secondary)
        return button
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Home", for: .normal)
        AppTheme.Elements.styleButton(button, withBackgroundColor: UIColor.systemGray4)
        return button
    }()
    
    // Custom circle layer instead of using a UIView
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    // MARK: - Initialization
    init(score: Int, totalQuestions: Int, quizSource: QuizSource) {
        self.score = score
        self.totalQuestions = totalQuestions
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
        configureResultDetails()
        
        // Add confetti animation if score is good
        let percentage = (Double(score) / Double(totalQuestions)) * 100
        if percentage >= 70 {
            setupConfettiAnimation()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        setupCircleProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateProgressCircle()
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
    
    private func setupCircleProgress() {
        // Calculate center position and size for the circle
        let centerX = resultsContainerView.center.x
        let centerY = titleLabel.frame.maxY + 130
        let circleSize: CGFloat = 180
        
        // Create circle path
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: circleSize / 2,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        // Background circle
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemGray5.cgColor
        circleLayer.lineWidth = 12
        circleLayer.strokeEnd = 1.0
        circleLayer.lineCap = .round
        view.layer.addSublayer(circleLayer)
        
        // Progress circle
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = AppTheme.Colors.secondary.cgColor
        progressLayer.lineWidth = 12
        progressLayer.strokeEnd = 0 // Will be animated
        progressLayer.lineCap = .round
        view.layer.addSublayer(progressLayer)
        
        // Position score label at the center of the circle
        scoreLabel.center = CGPoint(x: centerX, y: centerY)
        
        // Update view constraints for new layout
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: centerY)
        ])
    }
    
    private func setupConfettiAnimation() {
        confettiLayer = CAEmitterLayer()
        confettiLayer?.emitterPosition = CGPoint(x: view.center.x, y: -100)
        confettiLayer?.emitterShape = .line
        confettiLayer?.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        var cells: [CAEmitterCell] = []
        let colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemPurple]
        
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 4
            cell.lifetime = 8
            cell.lifetimeRange = 0
            cell.velocity = 150
            cell.velocityRange = 100
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3.5
            cell.spinRange = 0.5
            cell.color = color.cgColor
            cell.contents = UIImage(systemName: "star.fill")?.cgImage
            cell.scaleRange = 0.3
            cell.scale = 0.1
            
            cells.append(cell)
        }
        
        confettiLayer?.emitterCells = cells
        view.layer.addSublayer(confettiLayer!)
        
        // Stop emitting after a few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.confettiLayer?.birthRate = 0
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add subviews
        view.addSubview(homeButtonTop)
        view.addSubview(titleLabel)
        view.addSubview(resultsContainerView)
        view.addSubview(scoreLabel) // Score label now directly on the view
        resultsContainerView.addSubview(feedbackLabel)
        resultsContainerView.addSubview(statsContainerView)
        statsContainerView.addSubview(percentLabel)
        view.addSubview(restartButton)
        view.addSubview(homeButton)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Home button (top)
            homeButtonTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            homeButtonTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            homeButtonTop.widthAnchor.constraint(equalToConstant: 120),
            homeButtonTop.heightAnchor.constraint(equalToConstant: 30),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: homeButtonTop.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Results container - adjust the top to make room for the circles
            resultsContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 230),
            resultsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Feedback label
            feedbackLabel.topAnchor.constraint(equalTo: resultsContainerView.topAnchor, constant: 24),
            feedbackLabel.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 20),
            feedbackLabel.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -20),
            
            // Stats container
            statsContainerView.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 20),
            statsContainerView.leadingAnchor.constraint(equalTo: resultsContainerView.leadingAnchor, constant: 20),
            statsContainerView.trailingAnchor.constraint(equalTo: resultsContainerView.trailingAnchor, constant: -20),
            statsContainerView.heightAnchor.constraint(equalToConstant: 60),
            statsContainerView.bottomAnchor.constraint(equalTo: resultsContainerView.bottomAnchor, constant: -20),
            
            // Percent label
            percentLabel.centerXAnchor.constraint(equalTo: statsContainerView.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: statsContainerView.centerYAnchor),
            
            // Restart button
            restartButton.topAnchor.constraint(equalTo: resultsContainerView.bottomAnchor, constant: 30),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 240),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Home button
            homeButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 16),
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 240),
            homeButton.heightAnchor.constraint(equalToConstant: 50),
            homeButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Setup initial state with alpha=0 for animations
        scoreLabel.alpha = 0
        feedbackLabel.alpha = 0
        statsContainerView.alpha = 0
        restartButton.alpha = 0
        homeButton.alpha = 0
        
        // Add actions
        homeButtonTop.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    
    private func configureResultDetails() {
        scoreLabel.text = "\(score)/\(totalQuestions)"
        
        let percentage = (Double(score) / Double(totalQuestions)) * 100
        percentLabel.text = "Success: \(Int(percentage))%"
        
        // Set progress value
        let progress = CGFloat(score) / CGFloat(totalQuestions)
        
        // Set feedback message and colors based on score
        if percentage >= 80 {
            feedbackLabel.text = "Excellent! You have amazing knowledge about this topic."
            progressLayer.strokeColor = AppTheme.Colors.success.cgColor
            scoreLabel.textColor = AppTheme.Colors.success
        } else if percentage >= 60 {
            feedbackLabel.text = "Good job! You have a solid understanding of the topic."
            progressLayer.strokeColor = AppTheme.Colors.primary.cgColor
            scoreLabel.textColor = AppTheme.Colors.primary
        } else if percentage >= 40 {
            feedbackLabel.text = "Not bad! Keep studying to improve your score."
            progressLayer.strokeColor = AppTheme.Colors.accent.cgColor
            scoreLabel.textColor = AppTheme.Colors.accent
        } else {
            feedbackLabel.text = "You might need to study more and try again."
            progressLayer.strokeColor = AppTheme.Colors.error.cgColor
            scoreLabel.textColor = AppTheme.Colors.error
        }
    }
    
    private func animateProgressCircle() {
        // Animate the progress
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = CGFloat(score) / CGFloat(totalQuestions)
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnimation")
        
        // Animate the score and progress circle
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
            self.scoreLabel.alpha = 1
        })
        
        // Animate feedback and other UI elements
        UIView.animate(withDuration: 0.5, delay: 1.2, options: [], animations: {
            self.feedbackLabel.alpha = 1
            self.statsContainerView.alpha = 1
        })
        
        // Animate buttons
        UIView.animate(withDuration: 0.5, delay: 1.5, options: [], animations: {
            self.restartButton.alpha = 1
            self.homeButton.alpha = 1
        })
    }
    
    // MARK: - Actions
    @objc private func restartButtonTapped() {
        // Get quiz source details
        if case let .online(category, difficulty) = quizSource {
            // Show loading indicator
            let loadingAlert = UIAlertController(title: "Loading Questions", message: "Please wait...", preferredStyle: .alert)
            present(loadingAlert, animated: true)
            
            // Fetch new questions with the same category and difficulty
            apiService.fetchQuizQuestions(
                category: category,
                difficulty: difficulty
            ) { [weak self] result in
                // Dismiss loading indicator
                loadingAlert.dismiss(animated: true)
                
                switch result {
                case .success(let quiz):
                    self?.startNewQuiz(quiz: quiz)
                    
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func startNewQuiz(quiz: Quiz) {
        let viewModel = QuizViewModel(quiz: quiz)
        let quizVC = QuizViewController(viewModel: viewModel, quizSource: quizSource)
        
        // Replace the current quiz view controller with a new one
        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            // Remove the current results view controller
            viewControllers.removeLast()
            // Remove the previous quiz view controller
            viewControllers.removeLast()
            // Add the new quiz view controller
            viewControllers.append(quizVC)
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to fetch quiz questions: \(message)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func homeButtonTapped() {
        // Pop to root view controller (welcome screen)
        navigationController?.popToRootViewController(animated: true)
    }
} 