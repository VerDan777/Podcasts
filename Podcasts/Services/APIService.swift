//
//  APIService.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    let shared = APIService();
    
    static func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search";
        let parametrs:Parameters = ["term": searchText];
        
        Alamofire.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData  { (dt) in
            if let err = dt.error {
                print(err);
                return;
            }
            
            guard let data = dt.data else { return };
            
            let dummyString = String(data:data, encoding: .utf8);
            print(dummyString ?? "");
            
            do {
                let search = try JSONDecoder().decode(SearchResults.self, from: data);
                completionHandler(search.results);
            } catch let jsonError {
                print("err \(jsonError)")
            }
    }
    }
}
