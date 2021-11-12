//
//  MIMEError.swift
//  MIME
//

public enum MIMEError: Error {
    case readError(String)
    case writeError(String)
}
