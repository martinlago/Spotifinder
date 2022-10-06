//
//  ArtistDetailView.swift
//  Spotifinder
//
//  Created by Martín Lago on 5/10/22.
//

import SwiftUI
import SpotifyWebAPI

struct ArtistDetailView: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        ZStack {
            (colorScheme == .dark ? .clear : Color(.systemGray6))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                AsyncImage(url: homeViewModel.selectedArtist?.images?.first?.url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    // TODO: Add placeholder image
                    Text("X")
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .trailing) {
                    Text(homeViewModel.selectedArtist?.name ?? "No name")
                        .font(.system(size: 24, weight: .bold))
                }

                Spacer()

                List {
                    if homeViewModel.artistAlbums.count > 0 {
                        Section {
                            ForEach(homeViewModel.artistAlbums, id: \.self) { album in
                                ListItem(imageUrl: album.images?.last?.url, text: album.name)
                            }
                        } header: {
                            Text("Top albums")
                        }
                    }

                    Section {
                        ForEach(homeViewModel.artistTopTracks, id: \.self) { track in
                            ListItem(text: track.name, hideImage: true)
                        }
                    } header: {
                        Text("Top tracks")
                    }
                }
            }
            .redacted(reason: homeViewModel.isFetchingAlbums || homeViewModel.isFetchingTracks ? .placeholder : [])
        }
        .onAppear {
            homeViewModel.getArtistDetail()
        }
        .onDisappear {
            homeViewModel.clearSelectedArtistData()
        }
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailView()
    }
}