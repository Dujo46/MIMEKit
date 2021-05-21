//
//  MIMEText.swift
//  MIME
//

import Foundation

open class MIMEText: MIMEObject {
    // MARK: Public properties
    
    /// The body of the `MIMEText`. `7bit` is the default transfer encoding for data objects instantiated with this class.
    /// - Essentially the body of the email.
    public var data: String = ""
    
    /// Default header for plain text `MIMEObjects`
    public var header: [String: String] = [
        "Content-Type": "text/plain; charset=\"us-ascii\"",
        "MIME-Version": "1.0",
        "Content-Transfer-Encoding": "7bit"
    ]
    
    public init(using text: String) {
        self.data = text
    }
}

