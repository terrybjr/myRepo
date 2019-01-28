//
//  TheArtist+CoreDataProperties.swift
//  1000Museums
//
//  Created by Brian Terry on 1/27/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData


extension TheArtist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheArtist> {
        return NSFetchRequest<TheArtist>(entityName: "TheArtist")
    }

    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var name: String?
    @NSManaged public var workCount: Int16

}
