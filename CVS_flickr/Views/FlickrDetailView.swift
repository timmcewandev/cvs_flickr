//
//  FlickrDetailView.swift
//  CVS_flickr
//
//  Created by Tim McEwan on 3/26/25.
//

import SwiftUI

struct FlickrDetailView: View {
    var flickr: FlickrItem.Item?
    var body: some View {
        VStack(alignment: .leading) {
        Spacer()
            AsyncImage(url: URL(string: (flickr?.media.m)!)) {
                status in
                switch status {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .clipShape(Circle())
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
            .padding(.horizontal)
            .frame(width: 400, height: 400)
            VStack(alignment: .leading, spacing: 5) {
                Text("Description:")
                    .font(.title2)
                Text(attributedString(from: flickr?.description ?? ""))
                    .font(.body)
                Text("Author:")
                    .font(.title2)
                Text(attributedString(from: flickr?.author ?? "no author"))
                    .font(.body)
                
                Text("Date Published:")
                    .font(.title2)
                Text(flickr?.published?.formatted() ?? "no date")
                    .font(.body)
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle(flickr?.title ?? "")
        
        
    }
    
    func attributedString(from str: String) -> AttributedString {
        if let theData = str.data(using: .utf16) {
            do {
                let theString = try NSAttributedString(data: theData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return AttributedString(theString)
            } catch {  print("\(error)")  }
        }
        return AttributedString(str)
    }
        
}

#Preview {
    FlickrDetailView()
}
