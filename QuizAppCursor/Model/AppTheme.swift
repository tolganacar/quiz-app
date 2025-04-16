import UIKit

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let primary = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        static let secondary = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        static let accent = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        static let success = UIColor(red: 52.0/255.0, green: 199.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        static let error = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        static let background = UIColor.systemBackground
        static let secondaryBackground = UIColor.secondarySystemBackground
        static let text = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        
        static let gradient = [
            UIColor(red: 90.0/255.0, green: 120.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor,
            UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0).cgColor
        ]
    }
    
    // MARK: - Font Styles
    struct Fonts {
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let subtitle = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let button = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let caption = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    // MARK: - UI Element Styles
    struct Elements {
        // Button Style
        static func styleButton(_ button: UIButton, withBackgroundColor color: UIColor = Colors.primary) {
            button.backgroundColor = color
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = Fonts.button
            button.layer.cornerRadius = 12
            
            // Add shadow
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 3)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 0.15
        }
        
        // Card Style for View
        static func styleCard(_ view: UIView) {
            view.backgroundColor = Colors.secondaryBackground
            view.layer.cornerRadius = 16
            
            // Add shadow
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 8
            view.layer.shadowOpacity = 0.1
        }
        
        // Add gradient to view
        static func addGradientBackground(to view: UIView) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = Colors.gradient
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = view.bounds
            
            // Set a corner radius on the gradient layer
            gradientLayer.cornerRadius = 12
            
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
} 