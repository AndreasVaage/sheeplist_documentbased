//
//  SheepListError.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 04.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//
/*
Abstract:
This file contains the list of error codes that ShapeEdit can throw.
*/

/// These represent the possible errors thrown in our project.
enum SheepListError: Error {
    case ThumbnailLoadFailed
    case BookmarkResolveFailed
    case NoSheep
    case PlistReadFailed
    case SignedOutOfiCloud
}
