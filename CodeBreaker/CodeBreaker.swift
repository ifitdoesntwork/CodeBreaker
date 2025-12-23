//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Denis Avdeev on 23.12.2025.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode = Code(kind: .master)
    var guess = Code(kind: .guess)
    var attempts = [Code]()
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow]) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        attempts
            .append(.init(
                kind: .attempt(guess.match(against: masterCode)),
                pegs: guess.pegs
            ))
    }
    
    mutating func changeGuessPeg(at index: Int) {
        guess.pegs[index] = pegChoices
            .firstIndex(of: guess.pegs[index])
            .map { pegChoices[($0 + 1) % pegChoices.count] }
        ?? pegChoices.first
        ?? Code.missing
    }
}

struct Code {
    var kind: Kind
    var pegs = [Peg](repeating: Code.missing, count: 4)
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        pegChoices.indices
            .forEach {
                pegs[$0] = pegChoices.randomElement() ?? Code.missing
            }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): matches
        default: .init(repeating: .noMatch, count: 4)
        }
    }
    
    static let missing = Peg.clear
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .noMatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}
