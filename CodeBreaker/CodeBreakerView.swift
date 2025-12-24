//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Denis Avdeev on 22.12.2025.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var themedGame = ThemedCodeBreaker()
    var game: CodeBreaker { themedGame.game }
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            HStack {
                Text(themedGame.name)
                Spacer()
                Button("Restart") {
                    themedGame = ThemedCodeBreaker()
                }
            }
        }
        .padding()
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                peg(for: code, at: index)
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
    
    func peg(for code: Code, at index: Int) -> some View {
        pegView(for: code.pegs[index])
            .contentShape(Rectangle())
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                if code.kind == .guess {
                    themedGame.game.changeGuessPeg(at: index)
                }
            }
    }
    
    @ViewBuilder
    func pegView(for peg: Peg) -> some View {
        if let color = Color(named: peg) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(color)
        } else if peg == .missing {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray)
        } else {
            Color.clear
                .overlay {
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9 / 120)
                }
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                themedGame.game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    struct ThemedCodeBreaker {
        var game: CodeBreaker
        let name: String
        
        static let themes = [
            "Faces": ["😀", "😨", "🥳", "🤪", "😎"],
            "Vehicles": ["🚗", "🚲", "🛩", "⛵"],
            "Standard Colors": ["red", "green", "blue", "yellow"],
            "Earth Tone": ["brown", "yellow", "orange", "primary"]
        ]
        
        init() {
            name = Array(Self.themes.keys)[
                .random(in: 0..<Self.themes.count)
            ]
            game = .init(
                pegCount: .random(in: 3...6),
                pegChoices: Self.themes[name] ?? []
            )
        }
    }
}

extension Color {
    private static let namedColors: [String: Color] = [
        "red": .red, "green": .green, "blue": .blue,
        "yellow": .yellow, "orange": .orange, "purple": .purple,
        "pink": .pink, "cyan": .cyan, "indigo": .indigo,
        "mint": .mint, "teal": .teal, "brown": .brown,
        "gray": .gray, "black": .black, "white": .white,
        "clear": .clear, "primary": .primary, "secondary": .secondary,
        "accent": .accentColor
    ]
    
    init?(named name: String) {
        guard let color = Self.namedColors[name] else {
            return nil
        }
        self = color
    }
}

#Preview {
    CodeBreakerView()
}
