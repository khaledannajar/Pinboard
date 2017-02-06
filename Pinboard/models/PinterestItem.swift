//
//  PinterestItem.swift
//
//  Created by Khaled Annajar on 2/3/17
//  Copyright (c) Mind Valley. All rights reserved.
//

import Foundation
import SwiftyJSON

public class PinterestItem: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kPinterestItemHeightKey: String = "height"
  private let kPinterestItemUserKey: String = "user"
  private let kPinterestItemInternalIdentifierKey: String = "id"
  private let kPinterestItemLikesKey: String = "likes"
  private let kPinterestItemWidthKey: String = "width"
  private let kPinterestItemCreatedAtKey: String = "created_at"
  private let kPinterestItemUrlsKey: String = "urls"
  private let kPinterestItemCurrentUserCollectionsKey: String = "current_user_collections"
  private let kPinterestItemLinksKey: String = "links"
  private let kPinterestItemLikedByUserKey: String = "liked_by_user"
  private let kPinterestItemCategoryKey: String = "categories"
  private let kPinterestItemColorKey: String = "color"

  // MARK: Properties
  public var height: Int?
  public var user: User?
  public var internalIdentifier: String?
  public var likes: Int?
  public var width: Int?
  public var createdAt: String?
  public var urls: Urls?
  public var currentUserCollections: [Any]?
  public var links: Links?
  public var likedByUser: Bool = false
  public var categories: [Category]?
  public var color: String?

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
    height = json[kPinterestItemHeightKey].int
    user = User(json: json[kPinterestItemUserKey])
    internalIdentifier = json[kPinterestItemInternalIdentifierKey].string
    likes = json[kPinterestItemLikesKey].int
    width = json[kPinterestItemWidthKey].int
    createdAt = json[kPinterestItemCreatedAtKey].string
    urls = Urls(json: json[kPinterestItemUrlsKey])
    if let items = json[kPinterestItemCurrentUserCollectionsKey].array { currentUserCollections = items.map { $0.object} }
    links = Links(json: json[kPinterestItemLinksKey])
    likedByUser = json[kPinterestItemLikedByUserKey].boolValue
    if let items = json[kPinterestItemCategoryKey].array { categories = items.map { Category(json: $0) } }
    color = json[kPinterestItemColorKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = height { dictionary[kPinterestItemHeightKey] = value }
    if let value = user { dictionary[kPinterestItemUserKey] = value.dictionaryRepresentation() }
    if let value = internalIdentifier { dictionary[kPinterestItemInternalIdentifierKey] = value }
    if let value = likes { dictionary[kPinterestItemLikesKey] = value }
    if let value = width { dictionary[kPinterestItemWidthKey] = value }
    if let value = createdAt { dictionary[kPinterestItemCreatedAtKey] = value }
    if let value = urls { dictionary[kPinterestItemUrlsKey] = value.dictionaryRepresentation() }
    if let value = currentUserCollections { dictionary[kPinterestItemCurrentUserCollectionsKey] = value }
    if let value = links { dictionary[kPinterestItemLinksKey] = value.dictionaryRepresentation() }
    dictionary[kPinterestItemLikedByUserKey] = likedByUser
    if let value = categories { dictionary[kPinterestItemCategoryKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = color { dictionary[kPinterestItemColorKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.height = aDecoder.decodeObject(forKey: kPinterestItemHeightKey) as? Int
    self.user = aDecoder.decodeObject(forKey: kPinterestItemUserKey) as? User
    self.internalIdentifier = aDecoder.decodeObject(forKey: kPinterestItemInternalIdentifierKey) as? String
    self.likes = aDecoder.decodeObject(forKey: kPinterestItemLikesKey) as? Int
    self.width = aDecoder.decodeObject(forKey: kPinterestItemWidthKey) as? Int
    self.createdAt = aDecoder.decodeObject(forKey: kPinterestItemCreatedAtKey) as? String
    self.urls = aDecoder.decodeObject(forKey: kPinterestItemUrlsKey) as? Urls
    self.currentUserCollections = aDecoder.decodeObject(forKey: kPinterestItemCurrentUserCollectionsKey) as? [Any]
    self.links = aDecoder.decodeObject(forKey: kPinterestItemLinksKey) as? Links
    self.likedByUser = aDecoder.decodeBool(forKey: kPinterestItemLikedByUserKey)
    self.categories = aDecoder.decodeObject(forKey: kPinterestItemCategoryKey) as? [Category]
    self.color = aDecoder.decodeObject(forKey: kPinterestItemColorKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(height, forKey: kPinterestItemHeightKey)
    aCoder.encode(user, forKey: kPinterestItemUserKey)
    aCoder.encode(internalIdentifier, forKey: kPinterestItemInternalIdentifierKey)
    aCoder.encode(likes, forKey: kPinterestItemLikesKey)
    aCoder.encode(width, forKey: kPinterestItemWidthKey)
    aCoder.encode(createdAt, forKey: kPinterestItemCreatedAtKey)
    aCoder.encode(urls, forKey: kPinterestItemUrlsKey)
    aCoder.encode(currentUserCollections, forKey: kPinterestItemCurrentUserCollectionsKey)
    aCoder.encode(links, forKey: kPinterestItemLinksKey)
    aCoder.encode(likedByUser, forKey: kPinterestItemLikedByUserKey)
    aCoder.encode(categories, forKey: kPinterestItemCategoryKey)
    aCoder.encode(color, forKey: kPinterestItemColorKey)
  }

}
