# Simple news project 
## About
This is a simple news aggregator that I made in context of a test task for Quilix.
##### Basic features
* Simple REST-API connection with [News API] resource.
* On pull update and pagination fetching for each day separatly.
* Diffable data source searching.
* Adding downloaded news to Realm database. In case of network error, fetch from Realm(no pagination included). 
* Also added opening news on tap via Safari web services.
* VIPER pattern (Not perfect).

##### Libraries I used
* [Alamofire]  -- network connection
* [Realm]  -- database 
* [Kingfisher]  -- downloading and caching images from the web

## How to use
Download or clone repository and run comand in terminal in Simple-news folder:
```console
pod install
```
Then open Simple-news.xcworkspace file and run it in XCode! 

[News API]: https://newsapi.org/
[Alamofire]: https://github.com/Alamofire/Alamofire
[Realm]: https://realm.io/
[Kingfisher]: https://github.com/onevcat/Kingfisher
