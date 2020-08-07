//
//  LoadingIndicatorView.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

final class LoadingIndicatorView: UIView {
  let indicatorView = UIActivityIndicatorView()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialSetup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialSetup()
  }
  
  private func initialSetup() {
    backgroundColor = UIColor.black.withAlphaComponent(0.15)
    
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(indicatorView)
    
    let constraints: [NSLayoutConstraint] = [
      indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
      indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
