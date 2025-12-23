//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Denis Avdeev on 22.12.2025.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = newGame
    
    static var newGame: CodeBreaker {
        .init(
            pegCount: .random(in: 3...6),
            pegChoices: [.brown, .yellow, .orange, .primary]
        )
    }
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            Button("Restart") {
                game = Self.newGame
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
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                if code.pegs[index] == Code.missing {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray)
                }
            }
            .contentShape(Rectangle())
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(code.pegs[index])
            .onTapGesture {
                if code.kind == .guess {
                    game.changeGuessPeg(at: index)
                }
            }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
}

#Preview {
    CodeBreakerView()
}
