//
//  SearchViewModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation

extension SearchView {
    @Observable
    class ViewModel {
        struct Response: Decodable {
            var results: [Mountain] = []
        }
        var searchBarInput: String = ""
        var searchString: String = ""
        var searchResult: Response = .init()
        var searchPerfomed: Bool = false
        var isLoading: Bool = false
        var noResults: Bool = false
        
        func reset() {
            searchString = searchBarInput
            searchBarInput = ""
        }
        
        func performSearch() {
            self.reset()
            noResults = false
            searchPerfomed = true
            isLoading = true
            Task {
                @MainActor in
                
                do {
                    let request = URLRequest(url: URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=" + searchString)!)
                    let (data, _) = try await URLSession.shared.data(for: request)
                    do {
                        let results = try JSONDecoder().decode(Response.self, from: data)
                        self.searchResult.results = results.results.filter { $0.label == "MT" }
                        //self.searchResult.results = Array(Set(self.searchResult.results))

                    } catch {
                        print("No results")
                        noResults = true
                    }
                    isLoading = false
                } catch {
                    print("[ERROR] Posts fetch error ", error)
                }
            }
        }
    }
}
