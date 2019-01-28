//
//  Parser.swift
//  1000Museums
//
//  Created by Brian Terry on 1/27/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
// This class parses XML files and turns them into artist Objects.

import Foundation
class Parser: NSObject, XMLParserDelegate {
    private var artists: [TheArtist] = []
    private var currentElement = ""
    private var currentID: Int16 = 0
    private var currentName: String = ""
    private var currentWorkCount: Int16 = 0
    private var currentImagePath: String = ""
    
    func parseFeed(url: String){
        let theURL = URL(string: url)!
        let request = URLRequest(url: theURL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "Unknown Error")
                return
            }
            //parse the data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
        
    }
    // MARK - XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "Artist" {
            currentID = 0
            currentName = ""
            currentImagePath = ""
            currentWorkCount = 0
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "ID": currentID = Int16(string) ?? 0
        case "Name": currentName += string
        case "ImagePath": currentImagePath += string
        case "WorkCount": currentWorkCount = Int16(string) ?? 0
        default: break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Artist" {
            let artist = TheArtist(context: theModel.sharedInstance.persistenceManager.context)
            artist.id = self.currentID
            artist.imagePath = self.currentImagePath
            artist.name = self.currentName
            artist.workCount = self.currentWorkCount
            self.artists.append(artist)
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        print(artists)
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
