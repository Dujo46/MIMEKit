//
//  MIMEApplication.swift
//  MIME
//

import Foundation

open class MIMEApplication: MIMEObject {
    // MARK: - Public properties
    
    /// The body of the `MIMEApplication`. `base64` is the default encoding type for data objects instantiated with this class.
    public var data = ""
    
    /**
     The `MIMEApplication` header.
     
     Change or add header fields.
     
     ### Example ###
     ```
     let jpg = MIMEApplication(using: someData, filename: someFilename)
     jpg.header["Content-Type"] = "image/jpeg"
     ```
     */
    public var header: [String: String] = [
        "MIME-Version": "1.0",
        "Content-Transfer-Encoding": "base64",
    ]
    
    // MARK: - init
    
    /**
     - Parameter data: a `base64` encoded string that represents the object/body.
     - Parameter filename: the filename to be used in the `MIMEMultiPart` structure.
     - Warning: you must update the header's content type.
     */
    public init(using data: String, filename: String) {
        header["Content-Disposition"] = "attachment; filename=\"\(filename)\""
        self.data = data
    }
    
    /**
     - Parameter data: a `base64` encoded string that represents the object/body.
     - Parameter filename: the filename to be used in the `MIMEMultiPart` structure.
     - Parameter contentType: the type of content the data represents.
     */
    public init(using data: String, filename: String, contentType: MIMEType) {
        header["Content-Disposition"] = "attachment; filename=\"\(filename)\""
        header["Content-Type"] = contentType.rawValue
        self.data = data
        
    }
}

