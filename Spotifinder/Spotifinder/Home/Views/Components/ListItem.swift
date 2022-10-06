//
//  ListItem.swift
//  Spotifinder
//
//  Created by Martín Lago on 6/10/22.
//

import SwiftUI

struct ListItem: View {

    var imageUrl: URL?
    var text: String
    var hideImage: Bool = false
    var showChevron: Bool = false

    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 12) {
                if !hideImage {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        // TODO: Add placeholder image
                        Text("X")
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                }

                Text(text)
                    .font(.system(size: 16))
                    .lineLimit(1)
            }

            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.trailing, 2)
            }
        }
        .contentShape(Rectangle())
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(text: "Dummy text")
    }
}
