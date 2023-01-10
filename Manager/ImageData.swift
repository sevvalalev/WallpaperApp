//
//  ImageData.swift
//  WallpaperApp
//
//  Created by Sevval Alev on 9.01.2023.
//

import Foundation

struct ImageData: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Decodable {
    let id: String
    let urls: URLS?
}

struct URLS: Decodable {
    let regular: String
}
