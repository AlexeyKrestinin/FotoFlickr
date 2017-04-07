//
//  TopPlacesAPI.swift
//  FotoFlickr
//
//  Created by Алексей Крестинин on 04.04.17.
//  Copyright © 2017 Alexey Krestinin. All rights reserved.
//

import Foundation


class TopPlacesApi {
    
    enum APIError:Error {
        case wrongServerResponse
        case noPhotosFound
    }
    
    // https://api.flickr.com/services/rest/?
    //method=flickr.places.getTopPlacesList&api_key=1bb7a2e40d98ebac549d9a3888d27456&place_type_id=12&date=2017-04-02&place_id=1&format=json&nojsoncallback=1&api_sig=53bbfcfc8f00832a4e3f30bfb885cc58
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // Структура ссылки
    struct Constants {
        static let serviceURL = "https://api.flickr.com/services/rest/"
        static let method = "method"
        static let apiKey = "2b2c9f8abc28afe8d7749aee246d951c"
        static let placeTypeID = "8"
        static let date1 = "2017-04-02"
        
        static func buildWithURL(methodName: String) -> String {
            return Constants.serviceURL + "?" + Constants.method + "=" + methodName + "&api_key=" + Constants.apiKey + "&place_type_id=" + Constants.placeTypeID + "&date=" + Constants.date1 + "&place_id=1" + "&format=json&nojsoncallback=1"
            
        }
        
    }
    private func buildURL() -> URL {
        var urlString = Constants.buildWithURL(methodName: "flickr.places.getTopPlacesList")
        print("создали ссылку с методом\n\(urlString)")
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        print("итого:\n\(urlString)")
        
        return URL(string: urlString)!
    }
    
    // Получаем данные
    
    func getTopPlaces(
                //escaping означает, что это замыкание будет выполнено не в течение работы метода search
        //а когда-то потом
        success:@escaping( ([TopPlacesInfo])->Void ),
        failure:@escaping ( (Error)->Void ))
    {
        print("а сейчас мы обратимся к серверу")
        
        let url = self.buildURL()
        
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //данные получаются не мгновенно
        //и резальтат будет вызван уже после работы метода search
        //и после resumе
        //поэтому мы обязаны для замыканий success и failure
        //добавить @escaping
        let task:URLSessionTask = session.dataTask(with: url) { (data, response, error) in
            
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            print("\n=============data:\(String(describing:data)) \nresponse:\(String(describing:response)) \nerror:\(String(describing:error))")
            guard error == nil else {
                failure(error!)
                return
            }
            
            //убедимся, что ответ от сервера успешный
            guard let serverResponse = response as? HTTPURLResponse,
                //код ответа успешный
                serverResponse.statusCode == 200,
                //убедимся, что какие-то данные нам пришли
                //и мы их сможем преобразовать
                let jsonData = data else {
                    failure( APIError.wrongServerResponse )
                    return
            }
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData,
                                                                     options: []),
                let dictionary = jsonObject as? [String:Any] else {
                    failure(APIError.wrongServerResponse)
                    return
            }
            
            let places = self.buildPlaces(from: dictionary)
            
            
            guard places.count > 0 else {
                failure(APIError.noPhotosFound)
                return
            }
            success(places)
        }
        
        //запустим выполенение созданной задачи
        task.resume()
        
        //https://api.flickr.com/services/rest/?
        print("вызов метода search завершен")
    }
    
    private func buildPlaces(from dictionary:[String:Any])->[TopPlacesInfo]
    {
        //оппробуем прорваться через тернии ключей и значений
        //до массива с описанием фотографий
        guard let placeS = dictionary["places"] as? [String: Any] else {
            return []
        }
        guard let placeJSONs = placeS["place"] as? [ [String:Any] ] else {
            return []
        }
        
        var result = [TopPlacesInfo]()
        
        //пробежимся по словарям и попробуем из них получить
        //фотографии
        for placeJSON in placeJSONs {
            if let info = TopPlacesInfo(json: placeJSON){
                result.append(info)
            }
        }
        
        return result
    }
}
