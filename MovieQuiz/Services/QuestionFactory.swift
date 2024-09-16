import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var usedIndex: [Int] = []

    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    private var movies: [MostPopularMovie] = []

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self
            else { return }

            var index: Int
            repeat {
                index = (0..<self.movies.count).randomElement() ?? 0
            }  while self.usedIndex.contains(index)
            
            self.usedIndex.append(index)
            guard let movie = self.movies[safe: index] else {
                return
            }
            
            var imageData = Data()
            var imageLoadedSuccessfully = false
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                imageLoadedSuccessfully = !imageData.isEmpty
            } catch {
                print("Failed to load image")
            }
            if !imageLoadedSuccessfully {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let alertModel = AlertModel(
                        title: "Ошибка",
                        message: "Не удалось загрузить изображение фильма. Попробуйте еще раз.",
                        buttonText: "Ок") { [weak self] in
                            self?.loadData()
                        }
                    self.delegate?.presentAlert(alertModel)
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let numbers = (6..<10).randomElement() ?? 7
            let text = "Рейтинг этого фильма больше чем \(numbers)?"
            
            let correctAnswer = rating > Float(numbers)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
