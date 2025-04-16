import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - Properties
    private let apiService = QuizAPIService()
    private var selectedCategory: QuizCategory?
    private var selectedDifficulty: QuizDifficulty = .any
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.largeTitle
        label.textAlignment = .center
        label.text = "Quiz App"
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.subtitle
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Test your knowledge and improve yourself!"
        label.textColor = .white
        return label
    }()
    
    private let categoryContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        AppTheme.Elements.styleCard(view)
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.subtitle
        label.text = "Select Category"
        return label
    }()
    
    private lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private let difficultyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        AppTheme.Elements.styleCard(view)
        return view
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppTheme.Fonts.subtitle
        label.text = "Difficulty Level"
        return label
    }()
    
    private lazy var difficultySegmentedControl: UISegmentedControl = {
        let items = QuizDifficulty.allCases.map { $0.displayName }
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 3 // "Any" by default
        control.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // Add custom border to the segmented control
        control.layer.borderWidth = 3
        control.layer.borderColor = UIColor.clear.cgColor
        control.layer.cornerRadius = 8
        control.clipsToBounds = true
        
        return control
    }()
    
    private let fetchQuizButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Quiz", for: .normal)
        AppTheme.Elements.styleButton(button, withBackgroundColor: .systemGreen)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "brain.head.profile")
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        
        // Initial difficulty is 'any', so set the primary color for selected segment
        difficultySegmentedControl.layer.borderColor = UIColor.clear.cgColor
        difficultySegmentedControl.selectedSegmentTintColor = AppTheme.Colors.primary
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
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(categoryContainerView)
        categoryContainerView.addSubview(categoryLabel)
        categoryContainerView.addSubview(categoryPicker)
        containerView.addSubview(difficultyContainerView)
        difficultyContainerView.addSubview(difficultyLabel)
        difficultyContainerView.addSubview(difficultySegmentedControl)
        containerView.addSubview(fetchQuizButton)
        containerView.addSubview(activityIndicator)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Image view
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Subtitle label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Category container
            categoryContainerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            categoryContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            categoryContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Category label
            categoryLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 16),
            categoryLabel.centerXAnchor.constraint(equalTo: categoryContainerView.centerXAnchor),
            
            // Category picker
            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryPicker.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 10),
            categoryPicker.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -10),
            categoryPicker.heightAnchor.constraint(equalToConstant: 120),
            categoryPicker.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor, constant: -16),
            
            // Difficulty container
            difficultyContainerView.topAnchor.constraint(equalTo: categoryContainerView.bottomAnchor, constant: 20),
            difficultyContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            difficultyContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Difficulty label
            difficultyLabel.topAnchor.constraint(equalTo: difficultyContainerView.topAnchor, constant: 16),
            difficultyLabel.centerXAnchor.constraint(equalTo: difficultyContainerView.centerXAnchor),
            
            // Difficulty segmented control
            difficultySegmentedControl.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 16),
            difficultySegmentedControl.leadingAnchor.constraint(equalTo: difficultyContainerView.leadingAnchor, constant: 20),
            difficultySegmentedControl.trailingAnchor.constraint(equalTo: difficultyContainerView.trailingAnchor, constant: -20),
            difficultySegmentedControl.bottomAnchor.constraint(equalTo: difficultyContainerView.bottomAnchor, constant: -16),
            
            // Fetch quiz button
            fetchQuizButton.topAnchor.constraint(equalTo: difficultyContainerView.bottomAnchor, constant: 30),
            fetchQuizButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            fetchQuizButton.widthAnchor.constraint(equalToConstant: 240),
            fetchQuizButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Add actions
        fetchQuizButton.addTarget(self, action: #selector(fetchQuizButtonTapped), for: .touchUpInside)
        
        // Add animations
        animateElements()
    }
    
    private func animateElements() {
        // Initially set alpha to 0
        imageView.alpha = 0
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        categoryContainerView.alpha = 0
        difficultyContainerView.alpha = 0
        fetchQuizButton.alpha = 0
        
        // Animate with delay
        UIView.animate(withDuration: 0.7, delay: 0.1, options: [.curveEaseOut], animations: {
            self.imageView.alpha = 1
        })
        
        UIView.animate(withDuration: 0.7, delay: 0.3, options: [.curveEaseOut], animations: {
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 0.7, delay: 0.5, options: [.curveEaseOut], animations: {
            self.categoryContainerView.alpha = 1
        })
        
        UIView.animate(withDuration: 0.7, delay: 0.7, options: [.curveEaseOut], animations: {
            self.difficultyContainerView.alpha = 1
        })
        
        UIView.animate(withDuration: 0.7, delay: 0.9, options: [.curveEaseOut], animations: {
            self.fetchQuizButton.alpha = 1
        })
    }
    
    // MARK: - Actions
    @objc private func difficultyChanged(_ sender: UISegmentedControl) {
        selectedDifficulty = QuizDifficulty.allCases[sender.selectedSegmentIndex]
        
        // Update the border color and selected tint color based on the selected difficulty
        switch selectedDifficulty {
        case .easy:
            difficultySegmentedControl.layer.borderColor = UIColor.systemGreen.cgColor
            difficultySegmentedControl.selectedSegmentTintColor = UIColor.systemGreen
        case .medium:
            difficultySegmentedControl.layer.borderColor = UIColor.systemYellow.cgColor
            difficultySegmentedControl.selectedSegmentTintColor = UIColor.systemYellow
        case .hard:
            difficultySegmentedControl.layer.borderColor = UIColor.systemRed.cgColor
            difficultySegmentedControl.selectedSegmentTintColor = UIColor.systemRed
        case .any:
            difficultySegmentedControl.layer.borderColor = UIColor.clear.cgColor
            difficultySegmentedControl.selectedSegmentTintColor = AppTheme.Colors.primary
        }
    }
    
    @objc private func fetchQuizButtonTapped() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        apiService.fetchQuizQuestions(
            category: selectedCategory,
            difficulty: selectedDifficulty
        ) { [weak self] result in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            switch result {
            case .success(let quiz):
                let viewModel = QuizViewModel(quiz: quiz)
                let quizSource = QuizSource.online(category: self.selectedCategory, difficulty: self.selectedDifficulty)
                let quizVC = QuizViewController(viewModel: viewModel, quizSource: quizSource)
                self.navigationController?.pushViewController(quizVC, animated: true)
                
            case .failure(let error):
                self.showErrorAlert(message: error.localizedDescription)
            }
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
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension WelcomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return QuizCategory.allCases.count + 1 // +1 for "Any Category"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Any Category"
        } else {
            return QuizCategory.allCases[row - 1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedCategory = nil // Any category
        } else {
            selectedCategory = QuizCategory.allCases[row - 1]
        }
    }
} 
