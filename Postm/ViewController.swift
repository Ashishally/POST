//
//  ViewController.swift
//  Postm
//
//  Created by MAC on 23/02/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textId: UITextField!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtBody: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpPostMethod()
    }

    @IBAction func btnPostClicked(_ sender: UIButton) {
        self.setUpPostMethod()
    
    }
    
}

extension ViewController {
    
    func setUpPostMethod() {
        guard let uid = self.textId.text else {return}
        guard let title = self.txtTitle.text else {return}
        guard let body = self.txtBody.text else {return}
  
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
             var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            
            
            let parameters : [String : Any]  = [
                "userId" : uid,
                "title" : title ,
            "body" : body ]
            
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let data = data else {
                    if error == nil {
                        print(error?.localizedDescription ?? "Unknown Error")
                    }
                    
                    return
                    
                    
                }
                
                if let response = response as? HTTPURLResponse {
                    guard (200 ... 299) ~= response.statusCode else {
                        
                        print("Status Code :-  \(response.statusCode)")
                        print(response)
                        return
                        
                    }
                    
                }
                
                do  {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    
                } catch let error  {
                    print(error.localizedDescription)
                }
                
                
            }.resume()
        
        
        
        }
    
    
    
    }
    
}

extension Dictionary {
    func percentEscaped() -> String {
        return map  { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            
        }.joined(separator: "&")
        
        
    }
    
    
}


extension CharacterSet {
    
    
    static let urlQueryvalueAllowed: CharacterSet = {
        
        let generalDelimeterToEncode = ":#[]@"
        let subDelimetersToEncode = "!$&()*,+=;"
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimeterToEncode)\(subDelimetersToEncode)")
        
        return allowed
    }()
}
