//
//  ViewController.swift


import UIKit

struct Tweet {
    var username:String
    var tweetMSG:String
    var date:String
}

protocol APITwitterDelegate {
    func threatTheTweets(tweet:[Tweet])
    func error(error:NSError)
}

class DEL {
    var delegate: APITwitterDelegate?
    var token: String?
    
    init(delegate: APITwitterDelegate, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
//    https://twitter.com/search?l=&q=%22twitter%20premium%20api%22&src=typd&lang=en
    
    func getRequest(query: String)
    {
        
   let info = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(query)&count=100&lang=en&result_type=recent".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        print("\n\n\n", query, "\n\n\n")
 
        
        
        //BEARER AUTH
        var url = URLRequest(url: info!)
        url.httpMethod = "GET"
        url.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.error(error: error! as NSError)
            }
            else
            {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    print(dic)
                    var t : [Tweet] = []
                    let statuses: [NSDictionary] = (dic["statuses"] as? [NSDictionary])!
                    for d in statuses {
                        let name = d["user"] as! NSDictionary
                        let date = d["created_at"]
                        let text = d["text"]
                        t.append(Tweet(username: name.value(forKey: "name")! as! String, tweetMSG: text! as! String, date: date! as! String))
                    }
                    self.delegate?.threatTheTweets(tweet: t)
                }
                catch let err
                {
                    print(err)
                }
            }
        }
        task.resume()
    }

    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APITwitterDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: [Tweet] = []
    var access_token:String?

    func threatTheTweets(tweet:[Tweet]) {
        self.tweet = tweet
        self.tableView.reloadData()
    }
    
    func error(error: NSError) {
        print("\n=======Delegate Error Start=========\n", error, "\n=======Delegate Error End=========\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        let C_KEY = " "
        let C_Secret = " "
        
        let Bearer = ((C_KEY + ":" + C_Secret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + Bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("29", forHTTPHeaderField: "Content-Length")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            if nil != error {
                print(error!)
            }
            else if nil != data {
                do {
                    let dic : Dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    self.access_token = dic["access_token"] as? String
                    let del = DEL(delegate: self, token: self.access_token!)
                    del.getRequest(query: "#interviewprep")
                }
                catch let err
                {
                    print(err)
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "twitCell", for: indexPath) as! TwitCell
        cell.username.text = self.tweet[indexPath.row].username
        
        cell.dateLabel.text = self.tweet[indexPath.row].date
        cell.twitMSG.text = self.tweet[indexPath.row].tweetMSG
        return cell

    }
    

}

}

