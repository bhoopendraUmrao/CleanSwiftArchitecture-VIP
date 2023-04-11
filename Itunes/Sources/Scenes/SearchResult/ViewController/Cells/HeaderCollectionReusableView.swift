//
//  HeaderCollectionReusableView.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak private var titleLabel: UILabel!

    func setData(type: TypeSelectionProtocol) {
        titleLabel.text = type.title
    }
}
