//
//  MovieExpander.swift
//  CineMate
//
//  Created by Ritika Gupta on 22/11/24.
//

import Foundation
protocol MovieSectionExpander {
    func toggleCategory(
        categories: inout [ExpandableCategories],
        indexPath: IndexPath
    ) -> Bool
}

class DefaultMovieSectionExpander: MovieSectionExpander {
    func toggleCategory(categories: inout [ExpandableCategories], indexPath: IndexPath) -> Bool {
        guard indexPath.section < categories.count else {
            return (false)
        }
        
        let category = categories[indexPath.section]
        var shouldUpdate = false
        
        // Toggle section header
        if indexPath.row == 0 {
            category.isExpanded.toggle()
            categories[indexPath.section] = category
            shouldUpdate = true
            return (shouldUpdate)
        }
        
        var currentRow = 1
        for (subcategoryIndex, subcategory) in category.subCategories.enumerated() {
            if currentRow == indexPath.row {
                category.subCategories[subcategoryIndex].isExpanded.toggle()
                categories[indexPath.section] = category
                shouldUpdate = true
                return (shouldUpdate)
            }
            
            currentRow += 1
            
            if subcategory.isExpanded {
                currentRow += subcategory.movies.count
            }
        }
        return (shouldUpdate)
    }
}
