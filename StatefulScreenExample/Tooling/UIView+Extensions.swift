//
//  UIView+Rx.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {
  /// The opposite of isHidden property
  public var isVisible: Binder<Bool> {
    return Binder(base) { view, visible in
      view.isHidden = !visible
    }
  }
}

extension UIView {
  /// The opposite of isHidden property
  public var isVisible: Bool {
    get { !isHidden }
    set { isHidden = !newValue }
  }

  public func addStretchedToBounds(subview: UIView, insets: UIEdgeInsets? = nil) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subview)

    let constants = (insets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

    let constraints: [NSLayoutConstraint] = [
      subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constants.left),
      subview.topAnchor.constraint(equalTo: self.topAnchor, constant: constants.top),
      self.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: constants.right),
      self.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: constants.bottom),
    ]

    NSLayoutConstraint.activate(constraints)
  }
}

/// Как правило, ResetableView это также и ReusableView
public protocol ResetableView: AnyObject {
  /** Метод очищает текущие данные во View и сбрасывает её в дефолтное состояние.
   Отвественность за вызов метода лежит на том классе, который использует экземпляр ResetableView.
   Исключением являются awakeFromNib() или init() методы: здесь resetToEmptyState() вызвается, чтобы перед
   использованием view очистить из неё данные, которые уставлены в storyaboard'e и xib'e, и привести её в дефолтное
   состояние */
  func resetToEmptyState()
}

extension UIStackView {
  public func addArrangedSubviews(_ views: [UIView]) {
    views.forEach { addArrangedSubview($0) }
  }
}

extension UIColor {
  static let yellowMain: UIColor = #colorLiteral(red: 0.9803921569, green: 0.862745098, blue: 0.1725490196, alpha: 1)
}

extension Reactive where Base: UIRefreshControl {
  public var endRefreshing: Binder<Void> {
    Binder(base) { refreshControl, _ in
      refreshControl.endRefreshing()
    }
  }
}
