//
//  Document.swift
//  Reindeer
//
//  Created by Khoa Pham on 08/10/2016.
//  Copyright © 2016 Khoa Pham. All rights reserved.
//

import Foundation
import Clibxml2

class Document {

  enum DocumentKind {
    case xml, html
  }

  let xmlDocument: xmlDocPtr
  let rootElement: Element

  // MARK: - Initialization

  convenience init(string: String, encoding: String.Encoding = .utf8, kind: DocumentKind = .xml) throws {
    guard let data = string.data(using: encoding)
    else {
      throw InternalError.unknown
    }

    try self.init(data: data, kind: kind)
  }

  convenience init(data: Data, kind: DocumentKind = .xml) throws {
    let bytes = data.withUnsafeBytes {
      [Int8](UnsafeBufferPointer(start: $0, count: data.count))
    }

    try self.init(bytes: bytes)
  }

  convenience init(nsData: NSData, kind: DocumentKind = .xml) throws {
    var bytes = [UInt8](repeatElement(0, count: nsData.length))
    nsData.getBytes(&bytes, length:bytes.count * MemoryLayout<UInt8>.size)
    let data = Data(bytes: bytes)

    try self.init(data: data)
  }

  convenience init(bytes: [Int8], kind: DocumentKind = .xml) throws {
    let options: Int32

    switch kind {
    case .xml:
      options = Int32(XML_PARSE_NOWARNING.rawValue | XML_PARSE_NOERROR.rawValue | XML_PARSE_RECOVER.rawValue)
    case .html:
      options = Int32(HTML_PARSE_NOWARNING.rawValue | HTML_PARSE_NOERROR.rawValue | HTML_PARSE_RECOVER.rawValue)
    }

    guard let document = xmlReadMemory(bytes, Int32(bytes.count), "", nil, options)
    else {
      throw InternalError.lastError()
    }

    self.init(document: document)
  }

  init(document: xmlDocPtr) {
    self.xmlDocument = document
    self.rootElement = Element(node: xmlDocGetRootElement(document))
  }

  deinit {
    xmlFreeDoc(xmlDocument)
  }
}
