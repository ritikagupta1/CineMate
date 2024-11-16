//
//  OptionCellViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 15/11/24.
//

import Foundation

class OptionCellModel {
    let title: String
    let indentationLevel: Int
    let isExpanded: Bool
    
    init(title: String, indentationLevel: Int, isExpanded: Bool) {
        self.title = title
        self.indentationLevel = indentationLevel
        self.isExpanded = isExpanded
    }
}
