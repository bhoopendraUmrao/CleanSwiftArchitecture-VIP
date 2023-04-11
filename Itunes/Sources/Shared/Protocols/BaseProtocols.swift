//
//  BasePresentationLogic.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import Foundation

protocol BasePresentationLogic {
    func presentLoader()
    func dismissLoader()
}

protocol BaseDisplayLogic: AnyObject {
    func showLoader()
    func hideLoader()
}

protocol TypeSelectionProtocol {
    var title: String { get }
}
