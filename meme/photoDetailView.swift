//
//  photoDetailView.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/13.
//

import SwiftUI
import UIKit

struct photoDetailView: View {
    let photoId: String;
    @State private var memePhoto: MemePhoto?
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: memePhoto?.url ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 320, height: 320)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 8)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.secondary)
                    .frame(width: 320, height: 320)
            }

            Spacer()
            
            Button("download", action: {
                if let url = URL(string: memePhoto!.url),
                     let data = try? Data(contentsOf: url),
                     let image = UIImage(data: data) {
                     UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                 }
            })
        }
        .padding()
        .task {
            do {
                memePhoto = try await getMemePhoto()
            } catch {
                print("something went wrong")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Download Successfully!"),
                message: Text("Image has been saved to Photos"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func getMemePhoto() async throws -> MemePhoto {
        let endpoint = "https://us-central1-giggle-ff996.cloudfunctions.net/app/api/photos?filePath=\(photoId)"
        guard let url = URL(string: endpoint) else {
            throw MemeError.invalidURL
        }
    
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw MemeError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()

            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MemePhoto.self, from : data)
        } catch {
            throw MemeError.invalidData
        }
    }
}

struct MemePhoto: Codable {
    let url: String
}

enum MemeError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct photoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        photoDetailView(photoId: "cats/00a08d6b-cb86-4189-85df-fbd663aa1991.png")
    }
}
