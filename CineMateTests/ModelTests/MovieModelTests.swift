//
//  CineMateTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 14/11/24.
//

import XCTest
@testable import CineMate

class MoviesModelTests: XCTestCase {
    
    func test_movie_model_initialization() {
        // Given
        let movie = MoviesModelTests.createMockMovie()
        
        // Then
        
        // Stored Properties
        XCTAssertEqual(movie.title, "Meet the Parents")
        XCTAssertEqual(movie.year, "2000")
        XCTAssertEqual(movie.ratings.count, 3)
        
        // Computed Properties
        XCTAssertEqual(movie.directorCollection.count, 1)
        XCTAssertEqual(movie.actorCollection.count, 4)
        XCTAssertEqual(movie.genreCollection.count, 3)
        
        XCTAssertEqual(movie.genreCollection.first, "Comedy")
        XCTAssertEqual(movie.actorCollection.last, "Blythe Danner")
    }
    
    func test_genre_collection_splitting() {
        // Given
        let genres = MoviesModelTests.createMockMovie().genreCollection
        
        // Then
        XCTAssertEqual(genres, ["Comedy", "Romance", "Action"])
        XCTAssertEqual(genres[0], "Comedy")
        XCTAssertEqual(genres[1], "Romance")
        XCTAssertEqual(genres[2], "Action")
    }
    
    func test_actor_collection_splitting() {
        // Given
        let actors = MoviesModelTests.createMockMovie().actorCollection
        
        // Then
        XCTAssertEqual(actors, ["Robert De Niro", "Ben Stiller", "Teri Polo", "Blythe Danner"])
        XCTAssertEqual(actors[0], "Robert De Niro")
        XCTAssertEqual(actors[1], "Ben Stiller")
        XCTAssertEqual(actors[2], "Teri Polo")
        XCTAssertEqual(actors[3], "Blythe Danner")
    }
    
    func test_director_collection_splitting() {
        // Given
        let genres = MoviesModelTests.createMockMovie().directorCollection
        
        // Then
        XCTAssertEqual(genres, ["Jay Roach"])
        XCTAssertEqual(genres[0], "Jay Roach")
    }
    
    func test_movies_JSON_decoding_Success() throws {
        // Given
        guard let fileURL = Bundle.main.url(forResource: "movies", withExtension: "json"),
              let json = try? Data(contentsOf: fileURL) else {
            XCTFail()
            return
        }
        
        // When
        let movies = try JSONDecoder().decode([Movie].self, from: json)
        
        // Then
        XCTAssertNotNil(movies)
        XCTAssertEqual(movies.count, 19)
        XCTAssertEqual(movies.first?.title, "Meet the Parents")
        XCTAssertEqual(movies.last?.title, "Review")
    }
    
    func test_movies_JSON_decoding_Failure() throws {
        // Given
        let invalidJSON = """
                [ {
                        "Title": "Review",
                        "Year": "2014",
                        "Rated": "TV-14",
                        "Released": "27 Feb 2014",
                        "Runtime": "30 min",
                }]
                """.data(using: .utf8)!
        
        // When
        XCTAssertThrowsError(try JSONDecoder().decode([Movie].self, from: invalidJSON)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_empty_collections() {
            // Given
            let emptyMovie = Movie(
                title: "",
                year: "",
                rated: "",
                released: "",
                genre: "",
                director: "",
                writer: "",
                actors: "",
                plot: "",
                language: "",
                poster: "",
                ratings: []
            )
            
            // Then
            XCTAssertEqual(emptyMovie.genreCollection, [""])
            XCTAssertEqual(emptyMovie.directorCollection, [""])
            XCTAssertEqual(emptyMovie.actorCollection, [""])
            XCTAssertTrue(emptyMovie.ratings.isEmpty)
        }
}

extension MoviesModelTests {
    static func createMockMovie() -> Movie {
        return Movie(
            title: "Meet the Parents",
            year: "2000",
            rated: "PG-13",
            released: "06 Oct 2000",
            genre: "Comedy, Romance, Action",
            director: "Jay Roach",
            writer: "Greg Glienna, Mary Ruth Clarke, Greg Glienna (story), Mary Ruth Clarke (story), Jim Herzfeld (screenplay), John Hamburg (screenplay)",
            actors: "Robert De Niro, Ben Stiller, Teri Polo, Blythe Danner",
            plot: "A Jewish male nurse plans",
            language: "English, Thai, Spanish, Hebrew, French",
            poster: "https://m.media-amazon.com/images",
            ratings: [
                Rating(source: "Internet Movie Database", value: "7.0/10"),
                Rating(source: "Rotten Tomatoes", value: "84%"),
                Rating(source: "Metacritic", value: "73/100")
            ]
        )
    }
}
