//
//  Item+CoreDataProperties.swift
//  DreamLister
//
//  Created by Ahmed T Khalil on 2/7/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var toItemType: ItemType?
    @NSManaged public var toStore: Store?
    @NSManaged public var toPicture: Picture?

}
