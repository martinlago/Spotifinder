//
//  StringUtils.swift
//  Spotifinder
//
//  Created by Martín Lago on 6/10/22.
//

import Foundation

extension String {
    var capitalizedSentence: String {

        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
