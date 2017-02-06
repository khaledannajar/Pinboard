//
//  Category.swift
//
//  Created by Khaled Annajar on 2/3/17
//  Copyright (c) Mind Valley. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Category: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCategoryTitleKey: String = "title"
  private let kCategoryPhotoCountKey: String = "photo_count"
  private let kCategoryInternalIdentifierKey: String = "id"
  private let kCategoryLinksKey: String = "links"

  // MARK: Properties
  public var title: String?
  public var photoCount: Int?
  public var internalIdentifier: Int?
  public var links: Links?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    title = json[kCategoryTitleKey].string
    photoCount = json[kCategoryPhotoCountKey].int
    internalIdentifier = json[kCategoryInternalIdentifierKey].int
    links = Links(json: json[kCategoryLinksKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = title { dictionary[kCategoryTitleKey] = value }
    if let value = photoCount { dictionary[kCategoryPhotoCountKey] = value }
    if let value = internalIdentifier { dictionary[kCategoryInternalIdentifierKey] = value }
    if let value = links { dictionary[kCategoryLinksKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.title = aDecoder.decodeObject(forKey: kCategoryTitleKey) as? String
    self.photoCount = aDecoder.decodeObject(forKey: kCategoryPhotoCountKey) as? Int
    self.internalIdentifier = aDecoder.decodeObject(forKey: kCategoryInternalIdentifierKey) as? Int
    self.links = aDecoder.decodeObject(forKey: kCategoryLinksKey) as? Links
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(title, forKey: kCategoryTitleKey)
    aCoder.encode(photoCount, forKey: kCategoryPhotoCountKey)
    aCoder.encode(internalIdentifier, forKey: kCategoryInternalIdentifierKey)
    aCoder.encode(links, forKey: kCategoryLinksKey)
  }

}
