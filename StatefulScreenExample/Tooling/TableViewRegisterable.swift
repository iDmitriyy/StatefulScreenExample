//
//  TableViewRegisterable.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

public protocol DequeuableReusableView: AnyObject {
  /// Defines something that can be dequeued from a table view using a reuseIdentifier
  /// A cell that is defined in a storyboard should implement this.
  static var reuseIdentifier: String { get }
}

extension DequeuableReusableView {
  /// Default implementation of reuseIndentifier is to use the class name,
  /// this can be specifically implemented for difference behaviour
  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}

public protocol TableViewRegisterable: DequeuableReusableView {
  /// Defines something that can be registered with a table view, using the reuseIdentifer
  /// A cell that is laid out programmically or in a nib (that also implements NibLoadable) should implement this
}

extension UITableView {
  // MARK: Dequeue
  
  public func dequeue<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: DequeuableReusableView {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
    }
    return cell
  }
  
  // MARK: Register
  
  public func register<T: UITableViewCell>(_: T.Type) where T: TableViewRegisterable {
    register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  public func register<T: UITableViewCell>(_: T.Type) where T: TableViewRegisterable, T: NibLoadable {
    register(T.nib(), forCellReuseIdentifier: T.reuseIdentifier)
  }
}
