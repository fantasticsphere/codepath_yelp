// Playground - noun: a place where people can play

import UIKit

let yelpConsumerKey = "LYcHDMpWBe3hdJbWgpxTnQ"
let yelpConsumerSecret = "Z0q-ubOr6my46SP1ZWIXReKSYcE"
let yelpToken = "0rQpaXmTV6W74nQDBe3whjM8Ta4ts63A"
let yelpTokenSecret = "v6VzKw96lS9OCLW0FKe1noa_JBQ"

var client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
    println(response)
    }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println(error)
}
