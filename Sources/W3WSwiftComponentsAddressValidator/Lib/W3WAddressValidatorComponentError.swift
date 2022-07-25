//
//  File.swift
//  
//
//  Created by Dave Duprey on 25/05/2022.
//

import Foundation
import W3WSwiftApi
import W3WSwiftAddressValidators


/// Error type
public enum W3WAddressValidatorComponentError: Error, CustomStringConvertible {
  case unknown
  case internalInconsistancy
  
  case apiError(error: W3WError)
  case voiceSocketError(error: W3WVoiceSocketError)
  case microphoneError(error: W3WMicrophoneError)
  case addressValidator(error: W3WAddressValidatorError)
  
  public var description : String {
    switch self {
    case .unknown:                return "Unknown Address Validator error"
    case .internalInconsistancy:  return "Something went wrong internally"
      
    case .apiError(error: let error):  return String(describing: error)
    case .voiceSocketError(let error): return String(describing: error)
    case .microphoneError(let error):  return String(describing: error)
    case .addressValidator(let error): return String(describing: error)
    }
  }
  
}
