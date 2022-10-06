//
//  HomeView.swift
//  Spotifinder
//
//  Created by Martín Lago on 4/10/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct HomeView: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var homeViewModel: HomeViewModel

    @State var isArtistTapped: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? .clear : Color(.systemGray6))
                    .ignoresSafeArea()

                VStack {
                    TextField("Search artists", text: $homeViewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .onSubmit {
                            homeViewModel.searchArtists(query: homeViewModel.searchText)
                        }
                        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))

                    if homeViewModel.artists.isEmpty {
                        placeholderView
                    } else {
                        List {
                            ForEach(homeViewModel.artists, id: \.self) { artist in
                                buildArtistItem(artist)
                            }
                        }
                        .redacted(reason: homeViewModel.isFetchingArtists ? .placeholder : [])
                    }

                    Spacer()

                    NavigationLink("", destination: ArtistDetailView(), isActive: $isArtistTapped)

                }
            }
            .navigationTitle("Spotifinder")
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private var placeholderView: some View {
        VStack {
            Spacer()
            Text("Search for your favorite artists!")
            Spacer()
        }
    }

    private func buildArtistItem(_ artist: Artist) -> some View {
        ListItem(imageUrl: artist.images?.last?.url, text: artist.name, showChevron: true)
            .onTapGesture {
                homeViewModel.selectedArtist = artist
                isArtistTapped.toggle()
            }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
