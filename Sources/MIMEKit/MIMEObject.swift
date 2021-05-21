//
//  MIMEObject.swift
//  MIME
//

public protocol MIMEObject {
    var header: [String: String] { get set }
    var data: String { get set }
}

extension MIMEObject {
    /// A computed and properly formatted header string.
    ///
    /// The header of type `[String: String]` is operated on.
    /// - `.sorted`: Modifies the header to a sorted array of `Array<(key: String, value: String)>`.
    /// - `.map`: Modifies the sorted array to `[String]`
    /// - `.joined`: Joins the `[String]` elements into a `String`
    var headerData: String {
        header
            .sorted { $0.key < $1.key }
            .map { (key, value) -> String in
                "\(key): \(value)\r\n"
            }
            .joined()
    }
    
    
    /// Creates a properly formatted `String` that includes the header and data for a `part` in the `MIMEMultiPart` object.
    func createPartForMultiPart() -> String {
        [headerData, data]
            .joined(separator: "\r\n")
    }
}
