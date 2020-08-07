//
//  Tooling.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

public typealias VoidClosure = () -> Void

public protocol Namespace: CaseIterable {}

public protocol IOTransformer: AnyObject {
  associatedtype Input
  associatedtype Output

  func transform(_ input: Input) -> Output
}

public protocol BindableView: AnyObject {
  associatedtype Input
  associatedtype Output

  func getOutput() -> Output
  func bindWith(_ input: Input)
}

public struct TitledText: Hashable {
  public let title: String
  public let text: String

  public init(title: String, text: String) {
    self.title = title
    self.text = text
  }

  public static func makeEmpty() -> Self {
    .init(title: "", text: "")
  }
}

/// Для случаев, когда для отображения в UI'е нужна модель, дополненная заголовоком или пояснением
public struct TitledOptionalText: Hashable {
  public let title: String
  public let maybeText: String?

  public init(title: String, maybeText: String?) {
    self.title = title
    self.maybeText = maybeText
  }
}

public struct Empty: Hashable, Codable {
  public init() {}
}

/// Generic решение для closured-based инициализации
/// For class instances only. Value-types are not supported
public func configured<T: AnyObject>(object: T, closure: (_ object: T) -> Void) -> T {
  closure(object)
  return object
}
