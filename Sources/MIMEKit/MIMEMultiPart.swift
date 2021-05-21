//
//  MIMEMultiPart.swift
//  MIME
//

import Foundation

open class MIMEMultiPart: MIMEObject {
    // MARK: - Public properties
    
    /// The entire body, which includes all parts (attachments), for this `MIMEMultiPart` instance.
    public var data: String = ""
    
    /**
     The MIMEApplication header.
     
     Change or add header fields.
     
     ### Example ###
     If you want the output file to be in a `draft` or `unsent` state use the `"X-Unsent": "1"` field.
     ```
     let msg = MIMEMultiPart()
     print(msg.headerData)
     // Content-Type: multipart/mixed; boundary="<A UUID: SEE BOUNDARY PROPERTY>"
     // MIME-Version: 1.0
     
     msg.header["X-Unsent"] = "1"
     print(msg.headerData)
     // Content-Type: multipart/mixed; boundary="<A UUID: SEE BOUNDARY PROPERTY>"
     // MIME-Version: 1.0
     // X-Unsent: 1
     ```
     */
    public var header: [String: String] = ["MIME-Version": "1.0"] {
        didSet {
            updateDataString()
        }
    }
    
    // MARK: - Private Properties
    
    /// The unique line that separates each part of the `MIMEMultiPart` object.
    private var boundary: String = "\(UUID())"
    
    /// An array that contains each part of the `MIMEMultiPart` object.
    /// Can be thought of as the "attachments" or "components"
    /// The data property is updated each time there is an addition or removal from `parts`
    private var parts: [String] = [] {
        didSet {
            updateDataString()
        }
    }
    
    // MARK: - Public methods
    
    /// - Parameter object: The object that will be attached to this `MIMEMultiPart` instance.
    /// The string representation of the object will be created using `MIMEObject.createPartForMultiPart()`
    public func attach(_ object: MIMEObject) {
        parts.append(object.createPartForMultiPart())
    }
    
    /// - Parameter path: The path you want the file written to. You can use `eml` and `emltpl` file extensions.
    public func write(to path: String) throws {
        let url = URL(fileURLWithPath: path)
        do {
            try data.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw MIMEError.writeError("Could not create the file at path \(path)")
        }
    }
    
    // MARK: - Private Methods
    
    /// Updates the data property.
    ///
    /// A matrix array of String is operated on.
    /// - `.reduce`: Flattens the array.
    /// - `.joined`: Joins all of the Elements with the required boundary for the `MIMEMultiPart` data structure.
    /// - `.appending`: Adds the final boundary required to properly end the data structure.
    private func updateDataString() {
        self.data =  [[headerData], parts]
            .reduce([], +)
            .joined(separator: "\r\n--\(boundary)\r\n")
            .appending("\r\n--\(boundary)--")
    }
    
    // MARK: - init
    public init() {
        header["Content-Type"] = "multipart/mixed; boundary=\"\(boundary)\""
        updateDataString()
    }
}


// MARK: - Convenient methods
extension MIMEMultiPart {
    public func getParts() -> [String] {
        return parts
    }
    
    public func getPart(at index: Int) -> String {
        guard index < parts.count-1 && index > -1 else {
            fatalError("Index out of range.")
        }
        return parts[index]
    }
    
    public func removeAllParts() {
        self.parts.removeAll()
    }
    
    public func removePart(at index: Int) {
        guard index < parts.count-1 && index > -1 else {
            fatalError("Index out of range.")
        }
        parts.remove(at: index)
    }
}
