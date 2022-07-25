//
//  File.swift
//  
//
//  Created by Dave Duprey on 15/11/2021.
//

import Foundation
import W3WSwiftApi
import CoreLocation
import W3WSwiftInterfaceCommon
import W3WSwiftAddressValidators
import W3WSwiftUIInterfaceElements


/// state for the model
public enum W3WAddressModelState {
  case idle
  case listening
  case reading
  case communicating
  case results
  case found
  case error
  case debug
}


/// indicates the method on input
public enum W3WAddressInputMethod {
  case mic
  case text
}


/// The data for the component
public class W3WStreetAddressModel: ObservableObject {

  /// called when the user has chosen an address
  public var onAddressSelected: (W3WStreetAddressProtocol) -> () = { _ in }
  
  /// updates the mic icon to animate and represent recording level
  @Published public var recordingLevel: Double = 0.0
  
  /// the current state of the component
  @Published public var state: W3WAddressModelState = .idle
  
  /// this address structure is built as more and more informaiton is discovered from the APIs
  @Published public var addressTree: W3WValidatorNode?
  
  /// the current place in the tree where the user is
  @Published public var currentNode: W3WValidatorNode?

  /// holds info about the 3wa that the user is searching with
  public var suggestion: W3WSuggestion? = nil

  /// indicates if the user it entering text or voice
  public var inputMethod: W3WAddressInputMethod = .mic

  /// the loudest audio moment so far
  public var maxRecordingLevel: Double = 0.0
  
  /// the audio recording
  public var recorder = W3WAudioRecorder()

  /// the current address validation service we are using
  var service: W3WAddressValidatorProtocol!
  
  /// the what3words  API or SDK
  var w3w: W3WProtocolV3!
  
  /// the what3words voice service
  var voice: W3WVoiceUploadApi

  /// the users approximate location
  var focus: CLLocationCoordinate2D?
  
  /// error message if any
  var errorMessage: String?
  
  
  /// The data for the component
  /// - parameter w3w: the what3words  API or SDK
  /// - parameter voice: the voice service
  /// - parameter service: the current address validation service we are using
  /// - parameter focus: the users approximate location
  public init(w3w: W3WProtocolV3, voice: W3WVoiceUploadApi, service: W3WAddressValidatorProtocol, focus: CLLocationCoordinate2D?) {
    self.w3w = w3w
    self.service = service
    self.voice = voice
    set(focus: focus)
    
    configure()
  }
  
  
  /// The data for the component
  /// - parameter w3wApiKey: your what3words  API key
  /// - parameter service: the current address validation service we are using
  /// - parameter focus: the users approximate location
  public init(w3wApiKey: String, service: W3WAddressValidatorProtocol, focus: CLLocationCoordinate2D? = nil) {
    self.w3w = What3WordsV3(apiKey: w3wApiKey)
    self.service = service
    self.voice = W3WVoiceUploadApi(apiKey: w3wApiKey)
    set(focus: focus)
    
    configure()
  }
  
  
  /// The data for the component
  /// - parameter w3wApiKey: your what3words  API key
  /// - parameter swiftCompleteApiKey: your Swift Complete API key
  /// - parameter focus: the users approximate location
  public init(w3wApiKey: String, swiftCompleteApiKey: String, focus: CLLocationCoordinate2D? = nil) {
    self.w3w = What3WordsV3(apiKey: w3wApiKey)
    self.service = W3WAddressValidatorSwiftComplete(key: swiftCompleteApiKey)
    self.voice = W3WVoiceUploadApi(apiKey: w3wApiKey)
    set(focus: focus)
    
    configure()
  }
  
  
  /// The data for the component
  /// - parameter w3wApiKey: your what3words  API key
  /// - parameter data8ApiKey: your Data8 API key
  /// - parameter focus: the users approximate location
  public init(w3wApiKey: String, data8ApiKey: String, focus: CLLocationCoordinate2D? = nil) {
    self.w3w = What3WordsV3(apiKey: w3wApiKey)
    self.service = W3WAddressValidatorData8(key: data8ApiKey)
    self.voice = W3WVoiceUploadApi(apiKey: w3wApiKey)
    set(focus: focus)
    
    configure()
  }
  
  
  /// The data for the component
  /// - parameter w3wApiKey: your what3words  API key
  /// - parameter loqateApiKey: your Loqate API key
  /// - parameter focus: the users approximate location
  public init(w3wApiKey: String, loqateApiKey: String, focus: CLLocationCoordinate2D? = nil) {
    self.w3w = What3WordsV3(apiKey: w3wApiKey)
    self.service = W3WAddressValidatorLoqate(w3w: w3w, key: loqateApiKey)
    self.voice = W3WVoiceUploadApi(apiKey: w3wApiKey)
    set(focus: focus)
    
    configure()
  }

  
  /// configures the model
  func configure() {
    recorder.volumeUpdate = { recordingLevel in
      self.update(recordingLevel: recordingLevel)
    }
    
    recorder.listeningUpdate = { micState in
      self.update(state: micState)
    }
    
    recorder.recordingFinished = { recording in
      self.dealWithRecording(recording: recording)
    }
  }
  
  
  /// resets the component
  public func reset() {
    stopApiCalls()
    set(state: .idle)
  }
  
  
  public func stopApiCalls() {
    service?.cancel()
  }
  
  
  /// sets the user location
  /// parameter focus: the users location
  public func set(focus: CLLocationCoordinate2D?) {
    self.focus = focus
  }
  
  
  /// send the recording to the Voice API
  /// - parameter recording: the recording of the user uttering three words
  func dealWithRecording(recording: W3WAudioRecording) {
    self.set(state: .communicating)
    
    var options = [W3WOption]()
    
    // if there is a focus add an option
    if let f = focus {
      options.append(W3WOption.focus(f))
    }
    
    // call the voice API
    voice.autosuggest(audio: recording, options: options) { suggestions, error in
      if let e = error {
        self.update(error: e)
        
      // update the system with any results
      } else {
        self.update(suggestions: suggestions)
      }
    }
  }
  
  
  // once text is entered we call autosuggest
  func dealWithText(words: String) {
    self.set(state: .communicating)
    
    var options = [W3WOption]()
    
    if let f = focus {
      options.append(W3WOption.focus(f))
    }
    
    // call the API's autosuggest
    w3w.autosuggest(text: words, options: options) { suggestions, error in
      if let e = error {
        self.update(error: e)
        
      // update the system with any results
      } else {
        self.update(suggestions: suggestions)
      }
    }
  }
  
  
  /// called when there are new suggestions
  /// parameter suggestions: array of suggestions returned by the API
  func update(suggestions: [W3WSuggestion]?) {
    DispatchQueue.main.async {

      // call error if there are ne results
      if suggestions == nil {
        self.errorMessage = "No Results"
        self.set(state: .error)

      // call error if there are zero results
      } else if suggestions?.count == 0 {
        self.errorMessage = "No Results"
        self.set(state: .error)

      // use the top suggestion
      } else if let suggestion = suggestions?.first {
        
        // rememebr the suggestion
        self.suggestion = suggestion
        
        // make a node with the words to start the tree of addresses
        let suggestionNode = W3WValidatorNodeSuggestion(suggestion: suggestion)
        
        // top of the tree is a W3WSuggestion
        self.addressTree = suggestionNode
        
        // set the current node to the top
        self.currentNode = self.addressTree
        
        if let words = suggestion.words {
          
          // call the service for street addresses
          self.service.search(near: words) { addresses, error in
            DispatchQueue.main.async { 
              
              // if something went wrong
              if let e = error {
                self.errorMessage = e.description
                self.set(state: .error)
                
              // add the children to the graph
              } else {
                suggestionNode.children = addresses
                self.set(state: .results)
                DispatchQueue.main.async {
                  self.objectWillChange.send()
                }
              }
            }
          }
        }
      }
    }
  }
  
  
  // called when a used chooses an address node
  func addressChosen(address: W3WValidatorNodeLeaf, onAddressSelected: @escaping (W3WStreetAddressProtocol?) -> ()) {
    
    // get detailed info from the service (usually the money call)
    service.info(for: address) { fullAddress, error in
      if let a = fullAddress {
        self.set(state: .idle)
        onAddressSelected(a.address)
      }
      if let e = error {
        self.set(error: e.description)
      }
    }
  }
  
  
  // called when the user selects a node in the tree
  func nodeSelected(node: W3WValidatorNode) {
    if let listNode = node as? W3WValidatorNodeList {
      if listNode.children == nil || listNode.subItemCount == 0 {
        getChildNodes(node: listNode)
      }
    }
  }
  
  
//  func nodeShowing(node: W3WStreetAddressNode) {
//  }
    

  // get all the children for a particular node in the tree, and update the view once this is complete
  func getChildNodes(node: W3WValidatorNodeList) {
    
    // only call for chldren if they don't yet exist
    if node.children == nil {
      
      // get children from the service
      self.service.list(from: node) { addresses, error in
        node.children = addresses
        node.subItemCount = addresses.count
        
        // update the UI about the new data
        DispatchQueue.main.async {
          self.objectWillChange.send()
        }
      }
    }
  }
  

  /// called when there is a change in recording amplitude
  func update(recordingLevel: Double) {
    DispatchQueue.main.async {
      // update the recording level
      self.recordingLevel = recordingLevel
      
      // if we've hit a new maximum amplitude, then record that
      if self.maxRecordingLevel < recordingLevel {
        self.maxRecordingLevel = recordingLevel

      // slowly push the max recording value down over time until a new one comes in
      } else {
        self.maxRecordingLevel = self.maxRecordingLevel * 0.9
      }
    }
  }
  
  
  /// update the component's state
  func update(state: W3WVoiceListeningState) {
    if state == .stopped {
      self.stopRecording()
    } else {
      self.set(state: .listening)
    }
  }
  
  
  /// accessor to determine if the component is recording
  public func isRecording() -> Bool {
    return recorder.isRecording()
  }
  
  
  /// begin the voice recoding
  public func startRecording() {
    self.set(state: .listening)
    self.inputMethod = .mic
    recorder.start()
  }
  
  
  /// stop the voice recording
  public func stopRecording() {
    DispatchQueue.main.async {
      self.recorder.cancel()
      self.recordingLevel = 0.0
    }
  }
  

  /// show the user keyboard
  public func showKeyboard() {
    self.set(state: .reading)
    self.inputMethod = .text
  }
    

  /// called then a node is chosen
  func on(selected: W3WValidatorNodeLeafInfo) {
    self.set(state: .found)
    print(selected)
  }

  
  /// set the component's state
  /// - parameter state: the new state for the component
  func set(state: W3WAddressModelState) {
    DispatchQueue.main.async {
      // don't bother updating if the state is the same
      if self.state != state {
        print("STATE: ", self.state, " -> ", state)
        self.state = state
      }
      
      if state != .communicating {
        self.stopApiCalls()
      }
    }
  }
  
  
  /// figure out the state for the mic given the state of the model
  /// - Parameters:
  ///     - volume: the current amplitude
  func micStateFromModelState() -> W3WVoiceViewState {
    if state == .communicating {
      return .sending
    } else if state == .error {
      return .error
    } else if state == .listening {
      if isRecording() {
        return .listening
      } else {
        return .idle
      }
    } else {
      return .error
    }
  }

  
  /// sets the current error message
  public func set(error: String) {
    self.errorMessage = error
    self.set(state: .error)
  }
  
  
  /// called when an error happens, ultimately updates the view
  func update(error: W3WVoiceError) {
    DispatchQueue.main.async {
      self.errorMessage = error.localizedDescription
      self.set(state: .error)
    }
  }
  
  
  /// called when an error happens, ultimately updates the view
  func update(error: W3WError) {
    DispatchQueue.main.async {
      self.errorMessage = error.localizedDescription
      self.set(state: .error)
    }
  }
  
}
