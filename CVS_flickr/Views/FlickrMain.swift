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
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach($oo.flikerItems.indices, id: \.self) { indicies in
                        let photo = oo.flikerItems[indicies].media.m
                        AsyncImage(url: URL(string: (photo))) {
                            status in
                            switch status {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(10)
                                    .clipShape(Rectangle())
                                    .transition(.scale)
                            case .failure:
                                Image(systemName:"photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(10)
                                    .clipShape(Rectangle())
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
