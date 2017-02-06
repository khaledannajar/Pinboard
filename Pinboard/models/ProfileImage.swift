//
//  ProfileImage.swift
//
//  Created by Khaled Annajar on 2/3/17
//  Copyright (c) Mind Valley. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ProfileImage: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kProfileImageLargeKey: String = "large"
  private let kProfileImageSmallKey: String = "small"
  private let kProfileImageMediumKey: String = "medium"

  // MARK: Properties
  public var large: String?
  public var small: String?
  public var medium: String?

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
    large = json[kProfileImageLargeKey].string
    small = json[kProfileImageSmallKey].string
    medium = json[kProfileImageMediumKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = large { dictionary[kProfileImageLargeKey] = value }
    if let value = small { dictionary[kProfileImageSmallKey] = value }
    if let value = medium { dictionary[kProfileImageMediumKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.large = aDecoder.decodeObject(forKey: kProfileImageLargeKey) as? String
    self.small = aDecoder.decodeObject(forKey: kProfileImageSmallKey) as? String
    self.medium = aDecoder.decodeObject(forKey: kProfileImageMediumKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(large, forKey: kProfileImageLargeKey)
    aCoder.encode(small, forKey: kProfileImageSmallKey)
    aCoder.encode(medium, forKey: kProfileImageMediumKey)
  }

}
