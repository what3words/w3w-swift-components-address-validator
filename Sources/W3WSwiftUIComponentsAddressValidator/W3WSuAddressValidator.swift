//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 18/11/2021.
//

import SwiftUI
import CoreLocation
import W3WSwiftAddressValidators
import W3WSwiftUIInterfaceElements
import W3WSwiftDesign
import W3WSwiftApi


// expose these types from the W3WSwiftAddressValidators dependancy
public typealias W3WStreetAddressProtocol = W3WSwiftAddressValidators.W3WStreetAddressProtocol
public typealias W3WStreetAddressGeneric  = W3WSwiftAddressValidators.W3WStreetAddressGeneric
public typealias W3WStreetAddressUK       = W3WSwiftAddressValidators.W3WStreetAddressUK
public typealias W3WColor                 = W3WSwiftDesign.W3WColor
public typealias W3WCoreColor             = W3WSwiftDesign.W3WCoreColor


public struct W3WSuAddressValidator: View {

  @ObservedObject var model: W3WStreetAddressModel
  var controller: W3WStreetAddressController
  
  var colors: W3WSuAddressValidatorColors
  var onAddressSelected: (W3WStreetAddressProtocol?) -> ()


  public init(model: W3WStreetAddressModel, coordinates: CLLocationCoordinate2D? = nil, colors: W3WSuAddressValidatorColors = W3WSuAddressValidatorColors(), onAddressSelected: @escaping (W3WStreetAddressProtocol?) -> ()) {
    model.set(focus: coordinates)
   
    self.colors = colors
    self.onAddressSelected = onAddressSelected
    //= { node in onAddressSelected(controller.onAddressChosen(node: node)) }
    self.model = model
    
    controller = W3WStreetAddressController(model: model)
  }
  
  
  public init(w3wApiKey: String, swiftCompleteApiKey: String, coordinates: CLLocationCoordinate2D? = nil, colors: W3WSuAddressValidatorColors = W3WSuAddressValidatorColors(), onAddressSelected: @escaping (W3WStreetAddressProtocol?) -> ()) {
    let model = W3WStreetAddressModel(w3wApiKey: w3wApiKey, swiftCompleteApiKey: swiftCompleteApiKey, focus: coordinates)
    model.set(focus: coordinates)

    self.colors = colors
    self.onAddressSelected = onAddressSelected
    self.model = model
    
    controller = W3WStreetAddressController(model: model)
  }
  
  
  public init(w3wApiKey: String, data8ApiKey: String, coordinates: CLLocationCoordinate2D? = nil, colors: W3WSuAddressValidatorColors = W3WSuAddressValidatorColors(), onAddressSelected: @escaping (W3WStreetAddressProtocol?) -> ()) {
    let model = W3WStreetAddressModel(w3wApiKey: w3wApiKey, data8ApiKey: data8ApiKey, focus: coordinates)
    model.set(focus: coordinates)
    
    self.colors = colors
    self.onAddressSelected = onAddressSelected
    self.model = model
    
    controller = W3WStreetAddressController(model: model)
  }

  
  public init(w3wApiKey: String, lookupService: W3WAddressValidatorProtocol, coordinates: CLLocationCoordinate2D? = nil, colors: W3WSuAddressValidatorColors = W3WSuAddressValidatorColors(), onAddressSelected: @escaping (W3WStreetAddressProtocol?) -> ()) {
    let model = W3WStreetAddressModel(w3wApiKey: w3wApiKey, service: lookupService, focus: coordinates)
    model.set(focus: coordinates)
    
    self.colors = colors
    self.onAddressSelected = onAddressSelected
    self.model = model

    controller = W3WStreetAddressController(model: model)
  }

  
  public init(w3wApiKey: String, loqateApiKey: String, coordinates: CLLocationCoordinate2D? = nil, colors: W3WSuAddressValidatorColors = W3WSuAddressValidatorColors(), onAddressSelected: @escaping (W3WStreetAddressProtocol?) -> ()) {
    let model = W3WStreetAddressModel(w3wApiKey: w3wApiKey, loqateApiKey: loqateApiKey, focus: coordinates)
    model.set(focus: coordinates)
    
    self.colors = colors
    self.onAddressSelected = onAddressSelected
    self.model = model
    
    controller = W3WStreetAddressController(model: model)
  }
  
  
#if os(watchOS)
  public var body: some View {
    if model.state == .listening {
      W3WSuListen(state: model.micStateFromModelState(), recordingLevel: model.recordingLevel, maxRecordingLevel: model.maxRecordingLevel, colors: colors.main, onTap: { controller.onMicrophoneTap() }, onCancel: { controller.onCancel() })
      
    } else if model.state == .communicating {
      W3WSuListen(state: model.micStateFromModelState(), recordingLevel: model.recordingLevel, maxRecordingLevel: model.maxRecordingLevel, colors: colors.main, onTap: { controller.onMicrophoneTap() }, onCancel: { controller.onCancel() })
      
    } else if model.state == .error {
      W3WSuListen(state: model.micStateFromModelState(), recordingLevel: model.recordingLevel, maxRecordingLevel: model.maxRecordingLevel, colors: colors.main, onTap: { controller.onMicrophoneTap() }, onCancel: { controller.onCancel() })
        
    } else if model.state == .idle {
      W3WSuVoiceAndTextButtons(colors: colors.main, voiceAction: { self.controller.onVoiceChoosen() }, textAction: { self.controller.onTextChosen() })

    } else if model.state == .reading {
      W3WSuTextFieldWithButtons(colors: colors, onEntry: { words in controller.onWordsEntered(words: words) }, onCancel: { controller.onCancel() })

    } else if model.state == .found {
      Spacer()

    } else if model.state == .results {
      if let node = model.currentNode {
        #if !os(watchOS)
        NavigationView {
          W3WSuAddressNodeView(model: model, node: node, onAddressSelected: { node in getFullAddressDetailsAndCallback(node: node, completion: onAddressSelected)  }, colors: colors, onMicrophoneTap: { controller.onMicrophoneTap() })
        }
        #else
        W3WSuAddressNodeView(model: model, node: node, onAddressSelected: { node in getFullAddressDetailsAndCallback(node: node, completion: onAddressSelected)  }, colors: colors, onMicrophoneTap: { controller.onMicrophoneTap() })
        #endif

      } else {
        Text("ERROR: State == results, but no data found")
      }
      
    } else if model.state == .debug {
      Text("DEBUG")
      
    } else {
      Text("No such aplication state")
    }
  }


#else
  /// This view is only available for watchOS.  Though it does work on other platforms, it's not properly designed for the larger screens yet.
  public var body: some View { Text("This view is only available for watchOS").foregroundColor(colors.main.foreground.current.suColor).background(colors.main.background.current.suColor).cornerRadius(8.0) }
#endif
  
  func getFullAddressDetailsAndCallback(node: W3WValidatorNodeLeaf?, completion: @escaping (W3WStreetAddressProtocol?) -> ()) {
    controller.onAddressChosen(node: node, completion: completion)
  }
  
  
  
}
