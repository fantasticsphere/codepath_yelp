//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Paul Lo on 9/22/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BooleanFilterCellDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    
    var delegate: FiltersViewDelegate?
    
    let filterSpecs: [String:[[String:AnyObject]]] = [
        "most_popular": [
            [ "key": "deals_filter", "name": "Offerring a Deal"],
        ],
        "category_filter": [
            [ "key": "", "name": "All Categories"],
            [ "key": "active", "name": "Active Life"],
            [ "key": "arts", "name": "Arts & Entertainment"],
            [ "key": "auto", "name": "Automotive"],
            [ "key": "beautysvc", "name": "Beauty & Spas"],
            [ "key": "bicycles", "name": "Bicycles"],
            [ "key": "education", "name": "Education"],
            [ "key": "eventservices", "name": "Event Planning & Services"],
            [ "key": "financialservices", "name": "Financial Services"],
            [ "key": "food", "name": "Food"],
            [ "key": "health", "name": "Health & Medical"],
            [ "key": "homeservices", "name": "Home Services"],
            [ "key": "hotelstravel", "name": "Hotels & Travel"],
            [ "key": "localflavor", "name": "Local Flavor"],
            [ "key": "localservices", "name": "Local Services"],
            [ "key": "massmedia", "name": "Mass Media"],
            [ "key": "nightlife", "name": "Nightlife"],
            [ "key": "pets", "name": "Pets"],
            [ "key": "professional", "name": "Professional Services"],
            [ "key": "publicservicesgovt", "name": "Public Services & Government"],
            [ "key": "realestate", "name": "Real Estate"],
            [ "key": "religiousorgs", "name": "Religious Organizations"],
            [ "key": "restaurants", "name": "Restaurants"],
            [ "key": "shopping", "name": "Shopping"],
        ],
        "sort": [
            [ "key": "0", "name": "Best Match"],
            [ "key": "1", "name": "Distance"],
            [ "key": "2", "name": "Highest Rated"],

        ],
        "radius_filter": [
            [ "key": "", "name": "Auto"],
            [ "key": "483", "name": "0.3 miles"],
            [ "key": "1609", "name": "1 miles"],
            [ "key": "8047", "name": "5 miles"],
            [ "key": "32187", "name": "20 miles"],
        ],
    ]
    
    let filterNames: [String:String] = [
        "most_popular": "Offering a Deal",
        "category_filter": "Category",
        "sort": "Sort By",
        "radius_filter": "Distance",
    ]

    let filterCellTypes: [String:String] = [
        "most_popular": "booleanFilter",
        "category_filter": "radioFilter",
        "sort": "radioFilter",
        "radius_filter": "radioFilter",
    ]

    let sectionOrder = [
        "most_popular", "sort", "radius_filter", "category_filter"
    ]
    
    let categoryCollapsedViewMaxRows = 3
    
    var expanded: [String:Bool] = [
        "most_popular": true,
        "category_filter": false,
        "sort": false,
        "radius_filter": false,
    ]
    
    var expandable: [String:Bool] = [
        "most_popular": false,
        "category_filter": true,
        "sort": true,
        "radius_filter": true,
    ]
    
    var selected: [String: AnyObject] = [
        "most_popular" : [
            "deals_filter": false,
        ],
        "category_filter": 0,
        "sort": 0,
        "radius_filter": 0,
    ]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        self.filtersTableView.rowHeight = UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expanded[self.sectionOrder[section]]! {
            return self.filterSpecs[self.sectionOrder[section]]!.count
        } else {
            return self.sectionOrder[section] == "category_filter" ?
                (self.categoryCollapsedViewMaxRows + 1) : 1
        }
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionOrder.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.filterNames[self.sectionOrder[section]]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.filterCellTypes[self.sectionOrder[indexPath.section]]!) as FilterCell
        var values = self.filterSpecs[self.sectionOrder[indexPath.section]]!
        let sectionKey = self.sectionOrder[indexPath.section]

        if !self.expanded[sectionKey]! && sectionKey == "category_filter" && indexPath.row == self.categoryCollapsedViewMaxRows {
            var radioCell = cell as RadioFilterCell
            cell.setFilterName("See All", sectionKey: sectionKey, filterKey: "")
            radioCell.accessoryType = .None
        }
        else {
            if var booleanCell = cell as? BooleanFilterCell {
                booleanCell.delegate = self
                let selectedKeyInSection = values[indexPath.row]["key"]! as String
                let selectedValue = self.selected[sectionKey]![selectedKeyInSection] as Bool
                booleanCell.switchControl.setOn(selectedValue, animated: false)
                cell.setFilterName(values[indexPath.row]["name"]! as String, sectionKey: sectionKey, filterKey: selectedKeyInSection)
            } else if var radioCell = cell as? RadioFilterCell {
                let selectedIndexInSection = self.selected[sectionKey]! as Int
                if !self.expanded[sectionKey]! && sectionKey != "category_filter" {
                    let selectedKeyInSection = values[selectedIndexInSection]["key"]! as String
                    cell.setFilterName(values[selectedIndexInSection]["name"]! as String, sectionKey: sectionKey, filterKey: selectedKeyInSection)
                    radioCell.accessoryType = .Checkmark
                }
                else {
                    cell.setFilterName(values[indexPath.row]["name"]! as String, sectionKey: sectionKey, filterKey: values[indexPath.row]["key"]! as String)
                    radioCell.accessoryType = (selectedIndexInSection == indexPath.row ? .Checkmark : .None)
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionKey = self.sectionOrder[indexPath.section]
        if self.expandable[sectionKey]! {
            let sectionExpanded = self.expanded[sectionKey]!
            if sectionKey == "category_filter" {
                if !sectionExpanded && indexPath.row == self.categoryCollapsedViewMaxRows {
                    self.expanded[sectionKey] = true
                } else {
                    self.selected[sectionKey] = indexPath.row
                }
                //tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                tableView.reloadData()
            }
            else if var radioCell = tableView.cellForRowAtIndexPath(indexPath) as? RadioFilterCell {
                if sectionExpanded {
                    self.selected[sectionKey] = indexPath.row
                }
                self.expanded[sectionKey] = !sectionExpanded
                //tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                tableView.reloadData()
            }
        }
        println(self.selected)
    }

    func booleanFilterCell(cell: BooleanFilterCell, sectionKey: String, filterKey: String, selected: Bool) {
        var sectionSelections = self.selected[sectionKey]! as [String:Bool]
        sectionSelections[filterKey] = selected
        self.selected[sectionKey] = sectionSelections
        println("booleanFilterCell: \(self.selected)")
    }
    
    @IBAction func searchByFilter(sender: AnyObject) {
        println(self.selected)
        var filter: [String:AnyObject] = [:]
        filter["deals_filter"] = self.selected["most_popular"]!["deals_filter"]
        filter["category_filter"] = self.filterSpecs["category_filter"]![self.selected["category_filter"]! as Int]["key"]!
        filter["sort"] = self.filterSpecs["sort"]![self.selected["sort"]! as Int]["key"]!
        filter["radius_filter"] = self.filterSpecs["radius_filter"]![self.selected["radius_filter"]! as Int]["key"]!
        self.delegate?.filtersView(self, filter: filter)
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
