//
//  TypeCollectionViewCell.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import UIKit

final class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var titleLabel: UILabel!

    func setData(type: TypeSelectionProtocol) {
        titleLabel.text = type.title
    }
}
