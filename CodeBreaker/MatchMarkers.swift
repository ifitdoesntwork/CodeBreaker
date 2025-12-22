//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Denis Avdeev on 22.12.2025.
//

import SwiftUI

enum Match {
    case exact
    case inexact
    case noMatch
}

struct MatchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        let indices = matches.indices
            .filter { $0 % 2 == .zero }
        
        HStack {
            ForEach(indices, id: \.self) { index in
                VStack {
                    matchMarker(peg: index)
                    matchMarker(peg: index + 1)
                }
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount: Int = matches
            .count(where: { match in match == .exact })
        
        let foundCount: Int = matches
            .count(where: { match in match != .noMatch })
        
        return Circle()
            .fill(exactCount > peg ? Color.primary : .clear)
            .strokeBorder(
                foundCount > peg ? Color.primary : .clear,
                lineWidth: 2
            )
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    let matches = [Match.exact, .inexact, .noMatch]
    
    HStack {
        ForEach(matches.indices, id: \.self) { index in
            Circle()
        }
        MatchMarkers(matches: matches)
    }
    .padding()
}
