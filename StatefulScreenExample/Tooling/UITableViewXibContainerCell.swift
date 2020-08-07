//
//  UITableViewXibContainerCell.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

/// Позволяет использовать NibLoadable View'шки внутри TableView
/// Нужно создать дочерний класс и в качестве Generic-параметра указать тип View которую хочется переиспользовать
open class UITableViewXibContainerCell<T>: UITableViewContainerCell<T> where T: UIView & NibLoadable {
  open override class func makeViewInstanse() -> T {
    return T.loadFromNib()
  }
}

/// Позволяет использовать NibLoadable View'шки внутри TableView
/// Нужно создать дочерний класс и в качестве Generic-параметра указать тип View которую хочется переиспользовать
open class UITableViewContainerCell<T: UIView>: UITableViewCell, TableViewRegisterable {
  public let view: T
  
  public var contentViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
    didSet { contentConstraints.updateWith(contentViewInsets) }
  }
  
  private let contentConstraints = ContainerContentConstraints()
  
  /// Do not call super when overriding this method
  open class func makeViewInstanse() -> T {
    return T()
  }
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    view = type(of: self).makeViewInstanse()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    _initialSetup()
  }
  
  public required convenience init?(coder _: NSCoder) {
    /// super.init(coder: aDecoder)
    /// При назначении дочерних классов в сториборде не забывать корректно указывать reuseIdentifier
    /// в качестве reuseIdentifier – название класса
    self.init(style: .default, reuseIdentifier: type(of: self).reuseIdentifier)
  }
  
  /// Override this method in subClasses for setup during init() time. It's not necessary to call super when overriding
  open func initialSetup() {
    selectionStyle = .none
  }
  
  private func _initialSetup() {
    installView()
    initialSetup()
  }
  
  private func installView() {
    view.translatesAutoresizingMaskIntoConstraints = false
    let superView: UIView = contentView
    superView.addSubview(view)
    
    let leading = view.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: contentViewInsets.left)
    let trailing = superView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: contentViewInsets.right)
    let top = view.topAnchor.constraint(equalTo: superView.topAnchor, constant: contentViewInsets.top)
    let bottom = superView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: contentViewInsets.bottom)
    
    NSLayoutConstraint.activate([leading, trailing, top, bottom])
    
    contentConstraints.leading = leading
    contentConstraints.trailing = trailing
    contentConstraints.top = top
    contentConstraints.bottom = bottom
  }
}

public final class ContainerContentConstraints {
  public weak var top: NSLayoutConstraint?
  public weak var bottom: NSLayoutConstraint?
  public weak var leading: NSLayoutConstraint?
  public weak var trailing: NSLayoutConstraint?
  
  public init() {}
  
  public func updateWith(_ insets: UIEdgeInsets) {
    top?.constant = insets.top
    bottom?.constant = insets.bottom
    leading?.constant = insets.left
    trailing?.constant = insets.right
  }
}
