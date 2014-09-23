//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = ["term": term, "ll": "37.7833,-122.4167"]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }

    func searchWithTerm(term: String, filter: [String:AnyObject], success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = ["term": term, "ll": "37.7833,-122.4167"]
        if filter["sort"] != nil {
            parameters["sort"] = (filter["sort"]! as String)
        }
        if filter["category_filter"] != nil {
            let category_filter = filter["category_filter"]! as String
            if category_filter != "" {
                parameters["category_filter"] = category_filter
            }
        }
        if filter["radius_filter"] != nil {
            let radius_filter = filter["radius_filter"]! as String
            if radius_filter != "" {
              parameters["radius_filter"] = radius_filter
            }
        }
        if filter["deals_filter"] != nil && filter["deals_filter"]! as Bool {
            parameters["deals_filter"] = "true"
        }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
    
}
