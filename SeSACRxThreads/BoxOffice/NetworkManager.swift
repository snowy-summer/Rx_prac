//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/8/24.
//

import Foundation
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func callBoxOffice(date: String) -> Observable<Movie> {
       
        let url =
    "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=8c46cff2b27ce433c27cc0a5271983d6&targetDt=\(date)"
        
        return Observable<Movie>.create { observer in
        
            guard let url = URL(string: url) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let _ = error {
                    observer.onError(NetworkError.errrrrr)
                    return
                    
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkError.statusError)
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self,
                                                           from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                    return
                }
                
            }.resume()
            
            return Disposables.create()
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case statusError
    case errrrrr
}

