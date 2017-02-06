//
//  Links.swift
//
//  Created by Khaled Annajar on 2/3/17
//  Copyright (c) Mind Valley. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Links: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kLinksSelfLinkKey: String = "self"
  private let kLinksHtmlKey: String = "html"
  private let kLinksPhotosKey: String = "photos"
  private let kLinksDownloadKey: String = "download"
  private let kLinksLikesKey: String = "likes"

  // MARK: Properties
  public var selfLink: String?
  public var html: String?
  public var photos: String?
  public var download: String?
  public var likes: String?

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
    selfLink = json[kLinksSelfLinkKey].string
    html = json[kLinksHtmlKey].string
    photos = json[kLinksPhotosKey].string
    download = json[kLinksDownloadKey].string
    likes = json[kLinksLikesKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = selfLink { dictionary[kLinksSelfLinkKey] = value }
    if let value = html { dictionary[kLinksHtmlKey] = value }
    if let value = photos { dictionary[kLinksPhotosKey] = value }
    if let value = download { dictionary[kLinksDownloadKey] = value }
    if let value = likes { dictionary[kLinksLikesKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.selfLink = aDecoder.decodeObject(forKey: kLinksSelfLinkKey) as? String
    self.html = aDecoder.decodeObject(forKey: kLinksHtmlKey) as? String
    self.photos = aDecoder.decodeObject(forKey: kLinksPhotosKey) as? String
    self.download = aDecoder.decodeObject(forKey: kLinksDownloadKey) as? String
    self.likes = aDecoder.decodeObject(forKey: kLinksLikesKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(selfLink, forKey: kLinksSelfLinkKey)
    aCoder.encode(html, forKey: kLinksHtmlKey)
    aCoder.encode(photos, forKey: kLinksPhotosKey)
    aCoder.encode(download, forKey: kLinksDownloadKey)
    aCoder.encode(likes, forKey: kLinksLikesKey)
  }

}
