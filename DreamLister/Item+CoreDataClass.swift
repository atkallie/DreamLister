//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ahmed T Khalil on 2/7/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
