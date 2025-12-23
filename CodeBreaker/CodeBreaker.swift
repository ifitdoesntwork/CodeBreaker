//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Denis Avdeev on 23.12.2025.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    let masterCode: Code
    var guess: Code
    var attempts = [Code]()
    let pegChoices: [Peg]
    
    init(
        pegCount: Int,
        pegChoices: [Peg] = [.red, .green, .blue, .yellow],
    ) {
        var masterCode = Code(kind: .master, pegCount: pegCount)
        masterCode.randomize(from: pegChoices)
        self.masterCode = masterCode
        
        self.guess = .init(kind: .guess, pegCount: pegCount)
        self.pegChoices = pegChoices
        
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        guard
            !attempts.contains(where: { $0.pegs == guess.pegs })
            && !guess.pegs.contains(Code.missing)
        else {
            return
        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
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
    var pegs: [Peg]
    
    init(
        kind: Kind,
        pegCount: Int
    ) {
        self.kind = kind
        self.pegs = .init(repeating: Code.missing, count: pegCount)
    }
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        pegs.indices
            .forEach {
                pegs[$0] = pegChoices.randomElement() ?? Code.missing
            }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): matches
        default: .init(repeating: .noMatch, count: pegs.count)
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
