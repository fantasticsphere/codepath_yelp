//
//  FilterCell.swift
//  Yelp
//
//  Created by Paul Lo on 9/22/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    var sectionKey: String = ""
    var filterKey: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setFilterName(filterName: String, sectionKey: String, filterKey: String) {
        self.sectionKey = sectionKey
        self.filterKey = filterKey
    }
    
}