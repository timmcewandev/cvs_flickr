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
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100)), count: 2), spacing: 20) {
                    ForEach($oo.flikerItems.indices, id: \.self) { index in
                        let photo = oo.flikerItems[index].media.m
                        let accesslabel = oo.flikerItems[index].title
                        AsyncImage(url: URL(string: (photo))) {
                            status in
                            switch status {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .clipShape(Rectangle())
                                    .transition(.scale)
                                    .accessibilityHidden(false)
                                    .accessibilityAddTraits(.isImage)
                                    .accessibilityLabel(Text(accesslabel ?? "Tapable Image"))
                                    .accessibilityHint(Text("Tap to view details"))
                            case .failure:
                                Image(systemName:"photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .clipShape(Rectangle())
                                    .transition(.scale)
                                    .accessibilityHidden(false)
                                    .accessibilityAddTraits(.isImage)
                                    .accessibilityLabel(Text(accesslabel ?? "Picture is not available"))
                                    .accessibilityHint(Text("Tap to view details"))
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        // Mark: Tap indvidual picture
                        .onTapGesture {
                            if oo.flikerItems.indices.contains(index) {
                                selectedImage.toggle()
                                selectedIndicy = index
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .navigationDestination(isPresented: $selectedImage, destination: {
                    if let indicy = selectedIndicy, indicy >= 0, indicy < oo.flikerItems.count {
                        FlickrDetailView(flickr: oo.flikerItems[indicy])
                    }
                })
            }
            
        }
        .searchable(text: $oo.textName, prompt: "Search")
        .onChange(of: oo.textName) { value in
            selectedImage = false
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
