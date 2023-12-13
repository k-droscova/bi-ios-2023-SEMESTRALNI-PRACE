//
//  SearchView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var mountain: Mountain?
    @State private var viewModel: ViewModel = ViewModel()
    
    
    var body: some View {
        VStack(alignment: .center) {
            searchBar()
            .offset(x: 0, y: 0)
            .padding(.horizontal, 24)
            
            Spacer()
            
            searchResults()
            .frame(maxWidth: .infinity)
            .background(ignoresSafeAreaEdges: .horizontal)
            .listRowSeparator(.visible)
            .listRowInsets(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    private func searchBar() -> some View {
        HStack(alignment: .center) {
            TextField(
                "Start typing",
                text: $viewModel.searchBarInput,
                onCommit: {
                    viewModel.reset()
                    viewModel.performSearch()
                }
            )
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: viewModel.performSearch) {
                Image(systemName: "magnifyingglass")
            }
        }
    }
    
    private func searchResults() -> some View {
        List {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .modifier(CenterModifier())
            }
            else if (viewModel.noResults) {
                Text("No results")
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                    .offset(x: 0, y: 0)
                    .modifier(CenterModifier())
            }
            else {
                ForEach(viewModel.searchResult.results, id: \.self) {
                    result in
                    MountainSearchResultView(mountain: result)
                        .onTapGesture(perform:
                                        {mountain = result
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        )
                        .scaledToFit()
                }
            }
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(for: Mountain.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Mountain.self, configurations: config)
        return SearchView(mountain: .constant(Mountain.mountainMock1))
            .modelContext(container.mainContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}
