//
//  SeriesAPI.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 15/10/22.
//

import Foundation

enum Endpoint {
    var host: String {
        "https://api.tvmaze.com/"
    }
    
    case allSeries
    case serieDetail(Int)
    case search(String)
    
    func getUrl() -> String {
        switch self {
        case .allSeries: return host + "shows"
        case .serieDetail(let id): return host + "shows/\(id)?embed=episodes"
        case .search(let text): return host + "search/shows?q=\(text)"
        }
    }
}

protocol SeriesAPIProtocol {
    func getAllSeries() async throws -> [SerieResponse]
    func getSerieDetail(id: Int) async throws -> SerieResponse
    func searchSerie(text: String) async throws -> [SearchResponse]
}

class SeriesAPI: SeriesAPIProtocol {
    
    func getAllSeries() async throws -> [SerieResponse] {
        guard let url = URL(string: Endpoint.allSeries.getUrl()) else { fatalError("No URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Fetching Error") }
        let result = try JSONDecoder().decode([SerieResponse].self, from: data)
        return result
    }
    
    func getSerieDetail(id: Int) async throws -> SerieResponse {
        guard let url = URL(string: Endpoint.serieDetail(id).getUrl()) else { fatalError("No URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Fetching Error") }
        let result = try JSONDecoder().decode(SerieResponse.self, from: data)
        return result
    }
    
    func searchSerie(text: String) async throws -> [SearchResponse] {
        guard let url = URL(string: Endpoint.search(text).getUrl()) else { fatalError("No URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Fetching Error") }
        let result = try JSONDecoder().decode([SearchResponse].self, from: data)
        return result
    }
}
