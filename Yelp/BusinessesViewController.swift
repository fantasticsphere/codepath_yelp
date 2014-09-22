//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Paul Lo on 9/22/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

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
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        var terms = (self.navigationItem.titleView as UISearchBar).text
        client.searchWithTerm(terms, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
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
        if let imageUrl = business["image_url"]! as? String {
            cell.thumbnailView.setImageWithURL(NSURL(string: imageUrl))
        }
        if let businessName = business["name"]! as? String {
            cell.businessNameLabel.text = "\(indexPath.row+1). \(businessName)"
        }
        if let ratingImageUrl = business["rating_img_url_large"]! as? String {
            cell.ratingImageView.setImageWithURL(NSURL(string: ratingImageUrl))
        }
        if let distance = business["distance"]! as? Double {
            cell.distanceLabel.text = NSString(format: "%0.2f", distance * 0.00062137) + " mi"
        }
        if let reviewCount = business["review_count"]! as? Int {
            cell.reviewsLabel.text = "\(reviewCount) Reviews"
        }
        if let location = business["location"]! as? [String:AnyObject] {
            if let address = location["address"]! as? [String] {
                if address.count > 0 {
                    if let city = location["city"]! as? String {
                        cell.addressLabel.text = "\(address[0]), \(city)"
                    }
                }
            }
        }
        if let categories = business["categories"]! as? [[String]] {
            var categoriesText = ", ".join(categories.map({ $0[0] }))
            cell.categoriesLabel.text = categoriesText
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var business = self.businesses[indexPath.row]
        if let url = business["url"]! as? String {
            UIApplication.sharedApplication().openURL(NSURL(string: url))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
