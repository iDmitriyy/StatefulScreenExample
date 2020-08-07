//
//  ProfileProtocols.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

final class DisclosureTextCell: UITableViewXibContainerCell<DisclosureTextView> {
  override func prepareForReuse() {
    super.prepareForReuse()
    view.resetToEmptyState()
  }
}

final class DisclosureTextView: UIView, NibLoadable, ResetableView {
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    resetToEmptyState()
    initialSetup()
  }

  func resetToEmptyState() {
    textLabel.text = nil
  }

  func setText(_ text: String) {
    textLabel.text = text
  }

  private func initialSetup() {
    let image = UIImage(named: "accessory_arrow")
    imageView.image = image
  }
}
