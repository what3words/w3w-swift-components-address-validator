//
//  File.swift
//  
//
//  Created by Dave Duprey on 05/07/2022.
//

import UIKit
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftInterfaceCommon
import W3WSwiftInterfaceElements
import W3WSwiftComponents


public class W3WVoiceView: W3WMicWithHaloView, W3WOptionAcceptorProtocol {
  
  // Allow API key setting in IB
  @IBInspectable var apiKey: String = ""
  
  
  // MARK: Closures
  
  /// closure called when the recording starts and stops returning .started, or .stopped
  public var onStateChange: (W3WVoiceViewState) -> () = { _ in }
  
  /// closure called when suggestions are available
  public var onVoiceSuggestions: ([W3WVoiceSuggestion]?, W3WVoiceError?) -> () = { _,_ in }

  
  // MARK: Vars

  
  /// the API for making the voice calls
  var api: What3WordsV3?
  
  /// the audio to visualise
  var microphone: W3WMicrophone?
  
  /// the language to use
  var language = W3WSettings.defaultLanguage
  
  /// the autosuggest opotions for the voice call
  var options  = [W3WOption]()
  
  /// the last set volume number, this is the value we animate towards
  var targetVolume: CGFloat = 0.0
  
  /// the maximum volume passed in so far
  var maxVolume:CGFloat = 1.0
  
  /// the minimum volume passed in so far
  var minVolume:CGFloat = 0.0
  
  
  // MARK: Init
  
  
  public init(api: What3WordsV3, microphone: W3WMicrophone? = nil) {
    super.init(frame: CGRect(x: 0.0, y: 0.0, width: 64.0, height: 64.0))
    configure(api: api, microphone: microphone)
  }
  
  
  public init(frame: CGRect, api: What3WordsV3, microphone: W3WMicrophone? = nil) {
    super.init(frame: frame)
    configure(api: api, microphone: microphone)
  }
  
  
  public required init?(coder: NSCoder, api: What3WordsV3, microphone: W3WMicrophone? = nil) {
    super.init(coder: coder)
    configure(api: api, microphone: microphone)
  }
  
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure(api: What3WordsV3(apiKey: self.apiKey))
  }
  
  
  public func configure(api: What3WordsV3, microphone: W3WMicrophone? = nil) {
    self.microphone = microphone ?? W3WMicrophone()
    self.api = api
    
    self.microphone?.volumeUpdate = { volume in
      self.set(volume: volume)
    }
  }
  

  // MARK: Accessors
  
  /// sets all the options to use in voice recognition
  /// - Parameters:
  ///     - options: an array of W3WOption
  public func set(options: [W3WOption]) {
    self.options = options
  }
  
  
  override public func set(state: W3WVoiceViewState) {
    super.set(state: state)
    onStateChange(state)
  }
  
  
  /// sets the volume level to display.  this will automatically adjust for range.
  /// you can send in values from 0 -> 1, or -1000.0 -> 1000.0 or whatever and
  /// it will figure out the best place to show the halo
  /// - Parameters:
  ///     - v: the volume to show, can be a number of any value, the view will sort out how to display it relative to other values given to this function
  public override func set(volume: CGFloat) {
    
    // remember the min and max values
    if volume > maxVolume { maxVolume = volume }
    if volume < minVolume { minVolume = volume }
    
    maxVolume = maxVolume * 0.95
    if maxVolume < 0.1 {
      maxVolume = 0.1
    }
    
    if maxVolume == minVolume { maxVolume += 0.1 } // never end up with devide by zero (see next line)
    
    // figure out a good number between zero and one to represent the current volume, given the max values
    let range = maxVolume - minVolume
    let normalizedVolume = (volume - minVolume) / (range - minVolume)
    
    // the targetVolume is where the animation will try to get to (by incrementing 'self.volume'
    targetVolume = normalizedVolume
    
    // update the animation
    super.set(volume: targetVolume)
  }
  
  
  // MARK: Events
  
  
  override public func onTap() {
    if microphone?.isRecording() ?? false {
      // maybe we don't stop, but only start on a tap?
      //stopListening()

    } else {
      startListening()
    }
  }
  
  
  // MARK: Commands
  
  
  public func startListening() {
    if let m = microphone, let a = api {
      //set(state: .sending)
      a.autosuggest(audio: m, language: language, options: options) { [weak self] suggestions, error in
        if let e = error {
          self?.update(error: e)
        }
        self?.stopListening()
        self?.onVoiceSuggestions(suggestions, error)
      }
    }
    
    set(state: .listening)
    microphone?.start()
  }

  
  func stopListening() {
    set(state: .idle)
    microphone?.stop()
  }

  
  func update(error: W3WVoiceError) {
    self.set(state: .error)
  }
  
  
}
