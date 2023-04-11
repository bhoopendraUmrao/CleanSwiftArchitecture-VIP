//
//  TypeSelectionTableViewCell.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import UIKit

final class TypeSelectionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .white
    }

    func setData(type: TypeSelectionProtocol) {
        textLabel?.text = type.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // If selected is true the show checkmark else none
        accessoryType = selected ? .checkmark : .none
    }
}
