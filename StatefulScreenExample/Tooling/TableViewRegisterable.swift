//
//  TableViewRegisterable.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

// MARK: - Для строк

public protocol DequeuableReusableView: AnyObject {
  /// Defines something that can be dequeued from a table view using a reuseIdentifier
  /// A cell that is defined in a storyboard should implement this.
  static var reuseIdentifier: String { get }
}

extension DequeuableReusableView {
  /// Default implementation of reuseIndentifier is to use the class name,
  /// this can be specifically implemented for difference behaviour
  public static var reuseIdentifier: String {
    String(describing: self)
  }
}

public protocol TableViewRegisterable: DequeuableReusableView {
  /// Defines something that can be registered with a table view, using the reuseIdentifer
  /// A cell that is laid out programmically or in a nib (that also implements NibLoadable) should implement this
}

extension TableViewRegisterable where Self: UITableViewHeaderFooterView {
  public var reuseIdentifier: String? {
    Self.reuseIdentifier
  }
}

// MARK: - Для TableView

extension UITableView {
  // MARK: Dequeue

  public func dequeue<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: DequeuableReusableView {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
    }
    return cell
  }

  public func dequeue<T: UITableViewHeaderFooterView>() -> T? where T: DequeuableReusableView {
    dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
  }

  // MARK: Register

  public func register<T: UITableViewCell>(_: T.Type) where T: TableViewRegisterable {
    register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }

  public func register<T: UITableViewCell>(_: T.Type) where T: TableViewRegisterable, T: NibLoadable {
    register(T.nib(), forCellReuseIdentifier: T.reuseIdentifier)
  }

  public func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: TableViewRegisterable {
    register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }

  public func register<T: UITableViewHeaderFooterView>(_: T.Type)
    where T: TableViewRegisterable, T: NibLoadable {
    register(T.nib(), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }
}

// MARK: - Collection View

public protocol CollectionViewRegisterable: DequeuableReusableView {
  /// Defines something that can be registered with a collection view, using the reuseIdentifer
  /// A cell that is laid out programmically or in a nib (that also implements NibLoadable) should implement this
}

public protocol CollectionViewHeader: CollectionViewRegisterable {}

public protocol CollectionViewFooter: CollectionViewRegisterable {}

extension UICollectionView {
  // MARK: - Dequeue

  // Cells
  public func dequeue<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: DequeuableReusableView {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
    }

    return cell
  }

  // Header & Footer
  public func dequeueHeader<T>(forIndexPath indexPath: IndexPath) -> T
    where T: UICollectionReusableView & CollectionViewHeader {
    dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
  }

  public func dequeueFooter<T>(forIndexPath indexPath: IndexPath) -> T
    where T: UICollectionReusableView & CollectionViewFooter {
    dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, forIndexPath: indexPath)
  }

  /// This is private register method
  private func dequeueSupplementaryView<T>(ofKind kind: String, forIndexPath indexPath: IndexPath) -> T
    where T: UICollectionReusableView & CollectionViewRegisterable {
    guard let cell = dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: T.reuseIdentifier,
                                                      for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
    }

    return cell
  }
}

extension UICollectionView {
  // MARK: - Register

  // Cells
  public func register<T: UICollectionViewCell>(_: T.Type) where T: CollectionViewRegisterable {
    register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  public func register<T: UICollectionViewCell>(_: T.Type) where T: CollectionViewRegisterable, T: NibLoadable {
    register(T.nib(), forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  // Header & Footer
  public func registerHeader<T: UICollectionReusableView>(_: T.Type) where T: CollectionViewHeader {
    registerSupplementaryView(T.self, ofKind: UICollectionView.elementKindSectionHeader)
  }

  public func registerFooter<T: UICollectionReusableView>(_: T.Type) where T: CollectionViewFooter {
    registerSupplementaryView(T.self, ofKind: UICollectionView.elementKindSectionFooter)
  }

  private func registerSupplementaryView<T>(_: T.Type, ofKind kind: String)
    where T: UICollectionReusableView & CollectionViewRegisterable {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
  }

  // Nibloadable
  public func registerHeader<T: UICollectionReusableView>(_: T.Type)
    where T: CollectionViewHeader, T: NibLoadable {
    registerSupplementaryView(T.self, ofKind: UICollectionView.elementKindSectionHeader)
  }

  public func registerFooter<T: UICollectionReusableView>(_: T.Type)
    where T: CollectionViewFooter, T: NibLoadable {
    registerSupplementaryView(T.self, ofKind: UICollectionView.elementKindSectionFooter)
  }

  private func registerSupplementaryView<T>(_: T.Type, ofKind kind: String)
    where T: UICollectionReusableView, T: NibLoadable, T: CollectionViewRegisterable {
    register(T.nib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
  }
}
