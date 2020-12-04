import UIKit
import PlaygroundSupport

//APPError enum which shows all possible errors
enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//code to write json to the file
func outputJson(data:Data){
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        print(json,"\n\n\n")
        let file = "output.json"
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = dir[0].appendingPathComponent(file)
        print("JSON file is available at this path ", fileURL,"\n\n\n")
        let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        try data.write(to: fileURL, options: [.atomicWrite])
    }catch {
        print("Failed to write JSON data: \(error.localizedDescription)")
    }
}

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(APPError)
}

//dataRequest which sends request to given URL and convert to Decodable Object
func dataRequest<T: Decodable>(with url: URL, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {

    //create the session object
    let session = URLSession.shared

    //now create the URLRequest object using the url object
    let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: { data, response, error in

        guard error == nil else {
            completion(Result.failure(APPError.networkError(error!)))
            return
        }

        guard let data = data else {
            completion(Result.failure(APPError.dataNotFound))
            return
        }
        
        outputJson(data: data)

        do {
            //create decodable object from data
            let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
            completion(Result.success(decodedObject))
        } catch let error {
            completion(Result.failure(APPError.jsonParsingError(error as! DecodingError)))
        }
    })

    task.resume()
}

struct IMDbInfo: Decodable {
    let Title: String!
    let Year: String!
    let Plot: String!
    let imdbRating: String!
    let Error: String!
}

var title = "it"
var type = "movie"
var year = ""

if title != ""{
    var searchFields = "t=\(title)"
    if type != ""{
        searchFields = searchFields + "&type=\(type)"
    }
    if year != ""{
        searchFields = searchFields + "&y=\(year)"
    }
    
    //This line is used so that if any field has a space in it we can convert it into a format which can be converted to url
    //If we dont use this we get nil in url
    searchFields = searchFields.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    
    if let url = URL(string: "http://www.omdbapi.com/?apikey=56960628&\(searchFields)"){
        dataRequest(with: url, objectType: IMDbInfo.self) { (result: Result) in
                switch result {
                case .success(let object):
                    if let error = object.Error{
                        print(error)
                    }else if let Title = object.Title, let Year = object.Year, let Plot = object.Plot, let imdbRating = object.imdbRating{
                        print("Title: ", Title)
                        print("Year: ", Year)
                        print("Plot: ", Plot)
                        print("IMDb Rating: ", imdbRating)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }else{
        print("Error: Something went wrong")
    }
}else{
    print("Error: Title is required to search for the movie")
}

