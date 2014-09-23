//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Paul Lo on 9/22/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewDelegate {

    var client: YelpClient!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "LYcHDMpWBe3hdJbWgpxTnQ"
    let yelpConsumerSecret = "Z0q-ubOr6my46SP1ZWIXReKSYcE"
    let yelpToken = "0rQpaXmTV6W74nQDBe3whjM8Ta4ts63A"
    let yelpTokenSecret = "v6VzKw96lS9OCLW0FKe1noa_JBQ"
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var businessesTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var businesses: [[String:AnyObject]] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        searchBar.delegate = self
        searchBar.text = "French"
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)))
        
        self.businessesTableView.delegate = self
        self.businessesTableView.dataSource = self
        self.businessesTableView.rowHeight = UITableViewAutomaticDimension
        
        self.loadBusinessesFromSource()
    }

    func loadBusinessesFromSource() {
        loadBusinessesFromSource([:])
    }
    
    func loadBusinessesFromSource(filter: [String:AnyObject]) {
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        var terms = (self.navigationItem.titleView as UISearchBar).text
        client.searchWithTerm(terms, filter: filter, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println(response)
            if var businesses = response["businesses"] as? [[String:AnyObject]] {
                self.businesses = businesses
                self.businessesTableView.reloadData()
            }
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.loadBusinessesFromSource()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        for view in searchBar.subviews[0].subviews {
            if var searchBarTextField = view as? UITextField {
                searchBarTextField.enablesReturnKeyAutomatically = false
                break
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell

        var business = self.businesses[indexPath.row]
        if let imageUrl: AnyObject = business["image_url"] {
            cell.thumbnailView.setImageWithURL(NSURL(string: imageUrl as String))
        }
        if let businessName = (business["name"] ?? nil) as? String {
            cell.businessNameLabel.text = "\(indexPath.row+1). \(businessName)"
        } else {
            cell.businessNameLabel.text = "Unknown Business"
        }
        if let ratingImageUrl = (business["rating_img_url_large"] ?? nil) as? String {
            cell.ratingImageView.setImageWithURL(NSURL(string: ratingImageUrl))
        }
        if let distance = (business["distance"] ?? nil) as? Double {
            cell.distanceLabel.text = NSString(format: "%0.2f", distance * 0.00062137) + " mi"
        } else {
            cell.distanceLabel.text = ""
        }
        if let reviewCount = (business["review_count"] ?? nil) as? Int {
            cell.reviewsLabel.text = "\(reviewCount) Reviews"
        } else {
            cell.reviewsLabel.text = "No Review"
        }
        
        cell.addressLabel.text = ""
        if let location = (business["location"] ?? nil) as? [String:AnyObject] {
            if let address = location["address"]! as? [String] {
                if address.count > 0 {
                    if let city = location["city"]! as? String {
                        cell.addressLabel.text = "\(address[0]), \(city)"
                    }
                }
            }
        }
        
        cell.categoriesLabel.text = ""
        if let categories = (business["categories"] ?? nil) as? [[String]] {
            var categoriesText = ", ".join(categories.map({ $0[0] }))
            cell.categoriesLabel.text = categoriesText
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var business = self.businesses[indexPath.row]
        if let url = (business["url"] ?? nil) as? String {
            UIApplication.sharedApplication().openURL(NSURL(string: url))
        }
    }

    func filtersView(filtersView: FiltersViewController, filter: [String:AnyObject]) {
        println("filtersView: \(filter)")
        loadBusinessesFromSource(filter)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var filtersNavigationController = segue.destinationViewController as UINavigationController
        var filtersViewController = filtersNavigationController.viewControllers[0] as FiltersViewController
        filtersViewController.delegate = self
    }
    
}
