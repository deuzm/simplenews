# Simple news project 
## About
This is a simple news aggregator that I made in context of a test task for Quilix.
##### Basic features
* Simple REST-API connection with [News API] [1] resource.
* On pull update and pagination fetching for each day separatly.
* Diffable data source searching.
* Adding downloaded news to Realm database. In case of network error, fetch from Realm(no pagination included). 
* Also added opening news on tap via Safari web services.
* VIPER pattern (Not perfect).

##### Libraries I used
* [Alamofire] [2] -- network connection
* [Realm] [3] -- database 
* [Kingfisher] [4] -- downloading and caching images from the web

## How to use
Download or clone repository and run comand in terminal in Simple-news folder:
```console
pod install
```

[1]: https://newsapi.org/
[2]: https://github.com/Alamofire/Alamofire
[3]: https://realm.io/
[4]: https://github.com/onevcat/Kingfisher
