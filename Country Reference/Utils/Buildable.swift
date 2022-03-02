//
//  Buildable.swift
//  See gist: https://gist.github.com/kenalizadeh/8e2ea3ba6add5a9b9fe47c324c64bc6a
//

import Foundation

public protocol Buildable {
    init()
}

extension Buildable {
    /// Builds object applying passed block.
    /// - Parameter block: update block
    /// - Throws: rethrows
    /// - Returns: updated object
    public static func build(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var instance = Self.self.init()
        try block(&instance)
        return instance
    }

    /// Updates object with passed block by creating a copy of it.
    /// - Parameter block: update block
    /// - Throws: rethrows
    /// - Returns: updated object
    public func update(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }

    /// Mutates object with passed block by creating a copy of it.
    /// - Parameter block: update block
    /// - Throws: rethrows
    /// - Returns: updated object
    public mutating func mutate(_ block: (inout Self) throws -> Void) rethrows -> Self {
        try block(&self)
        return self
    }
}

extension NSObject: Buildable {}
