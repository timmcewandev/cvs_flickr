//
//  FlickrMain.swift
//  CVS_flickr
//
//  Created by Tim McEwan on 3/26/25.
//

import SwiftUI
import Combine

struct FlickrMain: View {
    // Mark: - State & StateObject
    @StateObject private var oo = NetworkManagerOO()
    @State var selectedImage: Bool = false
    @State var selectedIndicy: Int?
    
    
    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach($oo.flikerItems.indices, id: \.self) { indicies in
                        let photo = oo.flikerItems[indicies]
                        AsyncImage(url: URL(string: (photo.media.m))) {
                            status in
                            switch status {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(10)
                                    .clipShape(Rectangle())
                                    .transition(.scale)
                            case .failure:
                                Image(systemName:"photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .transition(.scale)
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                            
                        }
                        // Mark: Tap indvidual picture
                        .onTapGesture {
                            selectedImage.toggle()
                            selectedIndicy = indicies
                        }
                    }
                }
                .padding(.horizontal)
                .navigationDestination(isPresented: $selectedImage, destination: {
                    if let indicy = selectedIndicy {
                        FlickrDetailView(flickr: oo.flikerItems[indicy])
                    }
                })
            }
            
        }
        .searchable(text: $oo.textName, prompt: "Search")
        .onChange(of: oo.textName) { value in
            Task {
                oo.fetchFlickerImages(name: value)
            }
        }
        .task {
            oo.fetchFlickerImages(name: oo.textName)
        }
    }
}

#Preview {
    FlickrMain()
}
