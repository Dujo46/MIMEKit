# MIMEKit
MIMEKit is a minimal package written in 100% Swift that creates `eml` and `emltpl` documents using the Multipurpose Internet Mail Extensions standard - development focused on conformance with RFC 2045 - RFC 2049.

## Usage
The primary use case for this package will likely be the creation of `eml` and `emtpl` documents with text and attachments that open as a draft, ready to send, in an email client. Actual behavior is platform and email client-dependent based on their implementation of the MIME standard.

### Example
The following example does the following:
Creates a MIMEMultiPart message
Modifies the recipient, subject, and sent status (mark as unsent aka draft)
Creates the body text using MIMEText
Attaches a PDF document using MIMEApplication
```swift
import MIMEKit
import Foundation

// Create the base multipart object
// Think of this as the email object
let email = MIMEMultiPart()
email.header["To"] = "person@example.com"
email.header["Subject"] = "Weekly Reports"
email.header["X-Unsent"] = "1" // "Draft/unsent Status"

// A plain text object
// Think of this as the body of the email (in plain text)
let body = MIMEText(using: "Team,\n\nPlease review the attached document.\n\nVery Respectfully,\n- Coworker")

// Attach the body to the email
email.attach(body)

do {
  let pdfUrl = URL(fileURLWithPath: "/Path/To/The/File/Swift.pdf")
  let filename = pdfUrl.lastPathComponent
   
  guard FileManager.default.fileExists(atPath: pdfUrl.path) else {
    // Code here to handle when !.fileExists(atpath:)
    throw MIMEError.writeError("File does not exist.")
  }
   
  // Read your attachment as Data
  // Encode with base64EncodedString
  let pdfData = try Data.init(contentsOf: pdfUrl)
  let pdfEncodedString = pdfData.base64EncodedString()
   
  // Create attachment
  // You can rename the file here or use the default
  // This example uses the same filename as the original file
  // There are two init methods, the recomended init is init(using:filename:contentType:)
  let pdfAttachment = MIMEApplication(using: pdfEncodedString,
                    filename: filename,
                    contentType: .pdf)
   
  // Attach the pdf to the email
  email.attach(pdfAttachment)

} catch {
  fatalError("Error during Data.init(contentsOf:) : \(error.localizedDescription)")
}

// Write the document
// Use `emltpl` if you want to open the document as a draft
try email.write(to: "/Path/To/Your/Destination/testPackage.emltpl")
```
