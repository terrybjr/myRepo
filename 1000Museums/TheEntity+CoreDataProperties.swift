//
//  TheEntity+CoreDataProperties.swift
//  1000Museums
//
//  Created by Brian Terry on 1/27/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData


extension TheEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheEntity> {
        return NSFetchRequest<TheEntity>(entityName: "TheEntity")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?

}
