//
//  NibLoadable.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

/// Условия для работы фичи: xib файл должен называться как класс
public protocol NibLoadable: AnyObject {
  static var nibName: String { get }
  static var defaultNibBundle: Bundle { get }
  
  static func nib(fromBundle nibBundle: Bundle) -> UINib
  static func loadFromNib(inBundle nibBundle: Bundle) -> Self
  
  static func loadFromNib() -> Self
}

extension NibLoadable where Self: UIView {
  public static var nibName: String {
    return String(describing: self)
  }
  
  public static var defaultNibBundle: Bundle {
    return Bundle(for: self)
  }
  
  public static func nib(fromBundle nibBundle: Bundle = Self.defaultNibBundle) -> UINib {
    return UINib(nibName: nibName, bundle: nibBundle)
  }
  
  /// translatesAutoresizingMaskIntoConstraints по умолчанию равно false
  public static func loadFromNib(inBundle nibBundle: Bundle) -> Self {
    let view = nib(fromBundle: nibBundle)
      .instantiate(withOwner: self, options: nil).first as! Self // swiftlint:disable:this force_cast
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  /// translatesAutoresizingMaskIntoConstraints по умолчанию равно false
  public static func loadFromNib() -> Self {
    let nibBundle = Bundle(for: self)
    let view = loadFromNib(inBundle: nibBundle)
    return view
  }
}

extension NibLoadable where Self: UIView {
  /*
   На случай, когда одну view нужно много раз загружать. Можно ее nib сохранить и передавтаь в этот метод
   Позволяет немного ускорить процесс по сравнению с loadFromNib()
   */
  public static func loadFrom(cachedNib nib: UINib) -> Self {
    let view = nib.instantiate(withOwner: self, options: nil).first as! Self // swiftlint:disable:this force_cast
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
}
