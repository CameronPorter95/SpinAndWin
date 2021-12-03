//
//  Codable.swift
//  SpinAndWin
//

import Foundation
import SwiftyJSON

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return try? JSON(data: data).dictionaryObject?.filter { !($0.value is NSNull) }
  }
}

extension Encodable where Self: Codable {
  func merge<T: Codable>(with codable: Codable) -> T? {
    guard let dictOne = self.dictionary,
    let dictTwo = codable.dictionary else {
      return nil
    }
    let mergedDict = dictOne.merging(dictTwo) { (current, _) in current }
    let data = try! JSONSerialization.data(withJSONObject: mergedDict, options: [.prettyPrinted])
    return try! JSONDecoder().decode(T.self, from: data)
  }
}

extension Dictionary {
  func decode<T: Codable>() -> T? {
    let decoder = JSONDecoder()
    let data = try! JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    return try? decoder.decode(T.self, from: data)
  }
}
