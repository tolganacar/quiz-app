# Quiz App
![Simulator Screenshot - iPhone 16 Pro - 2025-04-16 at 17 39 14](https://github.com/user-attachments/assets/8dea9826-f336-40ed-9934-43498e0b6d64)
![Simulator Screenshot - iPhone 16 Pro - 2025-04-16 at 17 39 31](https://github.com/user-attachments/assets/ff356a96-570b-4abd-b479-4bdebb2fa950)
![Simulator Screenshot - iPhone 16 Pro - 2025-04-16 at 17 40 54](https://github.com/user-attachments/assets/d4e6e006-9c8f-4076-9dcd-32f05bc5ebf8)

A modern iOS quiz application that challenges users with knowledge questions across multiple categories and difficulty levels.

## Features

- **Online Quiz Questions**: Fetch trivia questions from a remote API
- **Multiple Categories**: Choose from various knowledge domains including General Knowledge, History, Science, Geography, and more
- **Difficulty Levels**: Select between Easy, Medium, Hard, or Any difficulty
- **Interactive UI**: Beautiful gradient backgrounds, animated transitions, and visual feedback
- **Progress Tracking**: Monitor your progress with a visual progress bar
- **Score Tracking**: Keep track of your score throughout the quiz
- **Results Summary**: Get detailed feedback on your performance with animated results display
- **Restart Option**: Start a new quiz with the same category and difficulty settings

## Technologies Used

- Swift
- UIKit
- Core Animation
- URLSession for API requests
- MVC architecture

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/tolganacar/quiz-app.git

2. Open the project in Xcode:
```bash
cd QuizApp
open QuizAppCursor.xcodeproj
```

3. Build and run the application on your preferred iOS simulator or device.

## Usage

1. **Launch the app**: Open the app to see the welcome screen
2. **Select a category**: Choose a knowledge category from the picker
3. **Choose difficulty**: Select your preferred difficulty level
4. **Start quiz**: Tap "Start Quiz" to begin
5. **Answer questions**: Select one of the multiple-choice options for each question
6. **View results**: After completing all questions, see your score and performance feedback
7. **Play again**: Choose to restart with the same settings or return to the home screen

## API Integration

The app uses the Open Trivia Database API to fetch questions. No API key is required for basic usage.

## Project Structure

- **Models/**: Data models including `Quiz`, `Question`, `QuizCategory`, and `QuizDifficulty`
- **Views/**: View controllers and custom UI components
- **ViewModel/**: Business logic for quiz management
- **Services/**: API service for fetching quiz questions


## License

```
Copyright tolganacar

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
