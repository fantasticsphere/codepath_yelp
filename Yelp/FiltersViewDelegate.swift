//
//  FiltersViewDelegate.swift
//  Yelp
//
//  Created by Paul Lo on 9/23/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate {
    
    func filtersView(filtersView: FiltersViewController, filter: [String:AnyObject])
   
}
