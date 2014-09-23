//
//  BooleanFilterCell.swift
//  Yelp
//
//  Created by Paul Lo on 9/22/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class BooleanFilterCell: FilterCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!

    var delegate: BooleanFilterCellDelegate?
    
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
    
    @IBAction func changeFilterValue(sender: UISwitch) {
        self.delegate?.booleanFilterCell(self, sectionKey: self.sectionKey, filterKey: self.filterKey, selected: sender.on)
        println("\(self.sectionKey), \(self.filterKey), \(sender.on)")
    }
}
