//
//  AppConstants.swift
//  Simple-news
//
//  Created by Лиза  Малиновская on 4/3/21.
//

import Foundation
import Alamofire

//Top headline news from all over the world
let API_NEWS_LIST: String = "https://newsapi.org/v2/everything"
let API_KEY: String = "98dabe0a6ef54136be76b37792d7b898"
let API_KEY2: String = "0987019d0d6d4ffe9b8d90982d242021"
let URL_TO_IMAGE: String = "https://i.imgflip.com/48jwa8.png"

let REQUEST_HEADERS: HTTPHeaders = [
    "X-Api-Key": API_KEY,
    "Accept": "application/json"
  ]
