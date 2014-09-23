//
//  RadioFilterCell.swift
//  Yelp
//
//  Created by Paul Lo on 9/22/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class RadioFilterCell: FilterCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setFilterName(filterName: String, sectionKey: String, filterKey: String) {
        super.setFilterName(filterName, sectionKey: sectionKey, filterKey: filterKey)
        self.filterNameLabel.text = filterName
    }
}
