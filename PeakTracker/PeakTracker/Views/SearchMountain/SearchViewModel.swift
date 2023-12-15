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
        var searchBarInput: String = "" // takes input from user
        var searchString: String = "" // the string that is sent to api
        var searchResult: Response = .init() // loads results from api
        var isFetching: Bool = false // to show progressView while fetching results
        var noResults: Bool = false // to show that there were no results for that specific search request
        
        private func clearSearchBar() {
            searchString = searchBarInput
            searchBarInput = ""
        }
        
        private func startSearch() {
            noResults = false
            isFetching = true
        }
        
        func performSearch() {
            self.clearSearchBar()
            self.startSearch() // sets the property flags accordingly
            Task {
                @MainActor in
                do {
                    let request = URLRequest(url: URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=" + searchString)!)
                    let (data, _) = try await URLSession.shared.data(for: request)
                    do {
                        let results = try JSONDecoder().decode(Response.self, from: data)
                        self.searchResult.results = results.results.filter { $0.label == "MT" }
                    } catch {
                        print("No results")
                        noResults = true
                    }
                    isFetching = false
                } catch {
                    print("[ERROR] Posts fetch error ", error)
                }
            }
        }
    }
}
