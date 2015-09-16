//
//  NoteAttribute.swift
//  NotePadApp
//
//  Created by SAALIS UMER on 07/09/15.
//  Copyright (c) 2015 SAALIS UMER. All rights reserved.
//

import Foundation
import CoreData
@objc(NoteAttribute)
class NoteAttribute: NSManagedObject {

    @NSManaged var font: String
    @NSManaged var size: Int16
    @NSManaged var bgColor: String
    @NSManaged var textColor: String

}
