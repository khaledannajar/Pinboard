//
//  Urls.swift
//
//  Created by Khaled Annajar on 2/3/17
//  Copyright (c) Mind Valley. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Urls: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUrlsFullKey: String = "full"
  private let kUrlsSmallKey: String = "small"
  private let kUrlsThumbKey: String = "thumb"
  private let kUrlsRegularKey: String = "regular"
  private let kUrlsRawKey: String = "raw"

  // MARK: Properties
  public var full: String?
  public var small: String?
  public var thumb: String?
  public var regular: String?
  public var raw: String?

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
    full = json[kUrlsFullKey].string
    small = json[kUrlsSmallKey].string
    thumb = json[kUrlsThumbKey].string
    regular = json[kUrlsRegularKey].string
    raw = json[kUrlsRawKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = full { dictionary[kUrlsFullKey] = value }
    if let value = small { dictionary[kUrlsSmallKey] = value }
    if let value = thumb { dictionary[kUrlsThumbKey] = value }
    if let value = regular { dictionary[kUrlsRegularKey] = value }
    if let value = raw { dictionary[kUrlsRawKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.full = aDecoder.decodeObject(forKey: kUrlsFullKey) as? String
    self.small = aDecoder.decodeObject(forKey: kUrlsSmallKey) as? String
    self.thumb = aDecoder.decodeObject(forKey: kUrlsThumbKey) as? String
    self.regular = aDecoder.decodeObject(forKey: kUrlsRegularKey) as? String
    self.raw = aDecoder.decodeObject(forKey: kUrlsRawKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(full, forKey: kUrlsFullKey)
    aCoder.encode(small, forKey: kUrlsSmallKey)
    aCoder.encode(thumb, forKey: kUrlsThumbKey)
    aCoder.encode(regular, forKey: kUrlsRegularKey)
    aCoder.encode(raw, forKey: kUrlsRawKey)
  }

}
