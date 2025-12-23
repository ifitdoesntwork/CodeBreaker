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
            pegChoices: Bool.random()
                ? ["😀", "😨", "🥳", "🤪", "😎"]
                : [PegColor.red, .green, .blue, .yellow].map(\.rawValue)
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
        pegView(for: code.pegs[index])
            .contentShape(Rectangle())
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                if code.kind == .guess {
                    game.changeGuessPeg(at: index)
                }
            }
    }
    
    @ViewBuilder
    func pegView(for peg: Peg) -> some View {
        if
            let pegColor = PegColor.allCases
                .first(where: { $0.rawValue == peg })
        {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(pegColor.color)
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
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
}

extension PegColor {
    
    var color: Color {
        switch self {
        case .red:
            .red
        case .green:
            .green
        case .blue:
            .blue
        case .yellow:
            .yellow
        }
    }
}

#Preview {
    CodeBreakerView()
}
