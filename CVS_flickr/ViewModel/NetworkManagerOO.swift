//
//  NetworkManagerOO.swift
//  CVS_flickr
//
//  Created by Tim McEwan on 3/26/25.
//

import Foundation
import Combine

class NetworkManagerOO: ObservableObject {
    @Published var flikerItems: [FlickrItem.Item] = []
    @Published var textName: String = "cheetah"
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    
    func fetchFlickerImages(name: String?) {
        guard let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(textName)") else {
            errorMessage = "Invalid URL"
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrItem.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] flikerItem in
                    DispatchQueue.main.async {
                        self?.flikerItems = flikerItem.items
                        self?.errorMessage = nil
                    }
                    
                }
            )
            .store(in: &cancellables)
    }
}
