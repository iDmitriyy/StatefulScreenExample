//
//  ErrorMessageView.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

final class ErrorMessageView: UIView, ResetableView {
  private let titleLabel = UILabel()
  private let button = UIButton()
  
  private var buttonAction: VoidClosure?
  
  // MARK: Overriden
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialSetup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialSetup()
  }
  
  // MARK: Public
  
  func resetToEmptyState() {
    titleLabel.text = nil
    button.setTitle(nil, for: .normal)
    buttonAction = nil
  }
  
  func setTitle(_ title: String, buttonTitle: String, action: @escaping VoidClosure) {
    titleLabel.text = title
    button.setTitle(buttonTitle, for: .normal)
    buttonAction = action
  }
  
  // MARK: Private
  
  @objc private func buttonTap() {
    buttonAction?()
  }
  
  private func initialSetup() {
    backgroundColor = UIColor.black.withAlphaComponent(0.15)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .yellowMain
    button.setTitleColor(.black, for: .normal)
    
    button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    
    addSubview(titleLabel)
    addSubview(button)
    
    let constraints: [NSLayoutConstraint] = [
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
      
      button.heightAnchor.constraint(equalToConstant: 70),
      button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 16),
      safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 16)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
