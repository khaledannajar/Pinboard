//
//  User.swift
//
//  Created by Khaled Annajar on 2/3/17
//  Copyright (c) Mind Valley. All rights reserved.
//

import Foundation
import SwiftyJSON

public class User: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserProfileImageKey: String = "profile_image"
  private let kUserLinksKey: String = "links"
  private let kUserNameKey: String = "name"
  private let kUserInternalIdentifierKey: String = "id"
  private let kUserUsernameKey: String = "username"

  // MARK: Properties
  public var profileImage: ProfileImage?
  public var links: Links?
  public var name: String?
  public var internalIdentifier: String?
  public var username: String?

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
    profileImage = ProfileImage(json: json[kUserProfileImageKey])
    links = Links(json: json[kUserLinksKey])
    name = json[kUserNameKey].string
    internalIdentifier = json[kUserInternalIdentifierKey].string
    username = json[kUserUsernameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = profileImage { dictionary[kUserProfileImageKey] = value.dictionaryRepresentation() }
    if let value = links { dictionary[kUserLinksKey] = value.dictionaryRepresentation() }
    if let value = name { dictionary[kUserNameKey] = value }
    if let value = internalIdentifier { dictionary[kUserInternalIdentifierKey] = value }
    if let value = username { dictionary[kUserUsernameKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.profileImage = aDecoder.decodeObject(forKey: kUserProfileImageKey) as? ProfileImage
    self.links = aDecoder.decodeObject(forKey: kUserLinksKey) as? Links
    self.name = aDecoder.decodeObject(forKey: kUserNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kUserInternalIdentifierKey) as? String
    self.username = aDecoder.decodeObject(forKey: kUserUsernameKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(profileImage, forKey: kUserProfileImageKey)
    aCoder.encode(links, forKey: kUserLinksKey)
    aCoder.encode(name, forKey: kUserNameKey)
    aCoder.encode(internalIdentifier, forKey: kUserInternalIdentifierKey)
    aCoder.encode(username, forKey: kUserUsernameKey)
  }

}
