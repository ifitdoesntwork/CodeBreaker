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
    let matches: [Match]
    
    var body: some View {
        let evenIndices = matches.indices
            .filter { $0 % 2 == .zero }
        
        HStack {
            ForEach(evenIndices, id: \.self) { index in
                VStack {
                    matchMarker(peg: index)
                    matchMarker(peg: index + 1)
                }
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches
            .count { $0 == .exact }
        
        let foundCount = matches
            .count { $0 != .noMatch }
        
        return Circle()
            .fill(exactCount > peg ? Color.primary : .clear)
            .strokeBorder(
                foundCount > peg ? Color.primary : .clear,
                lineWidth: 2
            )
            .aspectRatio(contentMode: .fit)
    }
}

// MARK: - Preview

struct MatchMarkersPreview: View {
    let matches: [Match]
    
    var body: some View {
        HStack {
            ForEach(matches.indices, id: \.self) { index in
                Circle()
            }
            MatchMarkers(matches: matches)
        }
        .padding()
    }
}

#Preview {
    VStack(alignment: .leading) {
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact])
        MatchMarkersPreview(matches: [.exact, .noMatch, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .exact])
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .noMatch, .noMatch])
        MatchMarkersPreview(matches: [.noMatch, .exact, .inexact, .exact, .exact, .noMatch])
        MatchMarkersPreview(matches: [.inexact, .exact, .inexact, .exact, .exact, .inexact])
        MatchMarkersPreview(matches: [.inexact, .exact, .inexact, .exact, .inexact])
        MatchMarkersPreview(matches: [.noMatch, .exact, .inexact, .noMatch, .inexact])
    }
}
