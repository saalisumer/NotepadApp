//
//  Note.swift
//  NotePadApp
//
//  Created by SAALIS UMER on 07/09/15.
//  Copyright (c) 2015 SAALIS UMER. All rights reserved.
//

import Foundation
import CoreData
@objc(Note)
class Note: NSManagedObject {

    @NSManaged var message: String
    @NSManaged var timeStampModified: NSTimeInterval
    @NSManaged var attribute: NoteAttribute

}
