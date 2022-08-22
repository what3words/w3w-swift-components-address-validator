//
//  VoiceViewController.swift
//  AddressValidation
//
//  Created by Dave Duprey on 24/06/2022.
//


import UIKit
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftInterfaceCommon
import W3WSwiftInterfaceElements
import W3WSwiftComponents


class W3WVoiceViewController: W3WViewController, W3WOptionAcceptorProtocol {

  /// called when a suggestion is ready
  var onSuggestions: ([W3WSuggestion]) -> () = { _ in }
  
  /// closure for error notifications
  var onError: (W3WVoiceError) -> () = { _ in }
  
  /// the voice api
  var api: What3WordsV3!
  
  /// autosuggest options to use
  var options: [W3WOption]? = nil
  
  /// the microphone view
  var microphoneView: W3WVoiceView!

  // sub views
  let titleLabel        = UILabel(frame: .w3wWhatever)
  let descriptionLabel   = UILabel(frame: .w3wWhatever)
  let logoView            = UIImageView(image: UIImage(named: "greyLogo"))
  let errorLabel           = UILabel(frame: .w3wWhatever)
  let errorDescriptionLabel = UILabel(frame: .w3wWhatever)

  // settings
  let micSize = CGFloat(192.0)
  let logoWidth = CGFloat(64.0)
  
  // functions for the view placements
  func logoFrame()         -> CGRect { return CGRect(x: view.center.x - logoWidth / 2.0, y: view.frame.height - logoWidth / 2.0 - self.view.safeAreaInsets.bottom, width: logoWidth, height: 11.0) }
  func titleFrame()         -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: view.center.y - micSize * 0.66, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 32.0) }
  func microphoneFrame()     -> CGRect { return CGRect(x: (view.frame.width - micSize) / 2.0, y: view.center.y - micSize / 2.0, width: micSize, height: micSize) }
  func descriptionFrame()     -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: microphoneFrame().maxY - W3WPadding.bold.value, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 32.0) }
  func errorDescriptionFrame() -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: titleFrame().maxY, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 48.0) }


  init(api: What3WordsV3) {
    super.init(nibName: nil, bundle: nil)
    self.api = api
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  // set the values for this view
  func set(title: String, description: String, error: String) {
    titleLabel.text = title
    descriptionLabel.text = description
    errorDescriptionLabel.text = error
  }
  
  
  // set options to use for the autosuggest
  func set(options: [W3WOption]) {
    self.options = options
    microphoneView?.set(options: options)
  }
  

  // set up the view
  override func viewDidLoad() {
    view.backgroundColor = W3WColor.background.current.uiColor

    // microphone
    microphoneView = W3WVoiceView(api: api)

    if let o = self.options {
      microphoneView.options = o
    }

    add(view: microphoneView, frame: microphoneFrame)

    // the title
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
    add(view: titleLabel, frame: titleFrame)

    // the footer
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
    add(view: descriptionLabel, frame: descriptionFrame)

    // show any error
    errorDescriptionLabel.textAlignment = .center
    errorDescriptionLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
    errorDescriptionLabel.textColor = W3WCoreColor.grey38.uiColor
    errorDescriptionLabel.numberOfLines = 2
    errorDescriptionLabel.minimumScaleFactor = 0.5
    errorDescriptionLabel.adjustsFontSizeToFitWidth = true
    add(view: errorDescriptionLabel, frame: errorDescriptionFrame)

    // add the logo
    add(view: logoView, frame: logoFrame)

    // update whomever is interested when there si a state change
    microphoneView.onStateChange = { state in
      self.update(state: state)
    }
    
    // when suggestions come in, deal with them
    microphoneView.onVoiceSuggestions = { [weak self] suggestions, error in
      if let e = error {
        self?.microphoneView.set(state: .error) // consider no suggestions an error state
        self?.onError(e)

      } else if suggestions?.count ?? 0 == 0 {
        self?.microphoneView.set(state: .error) // consider no suggestions an error state
        
      } else {
        self?.onSuggestions(suggestions ?? [])
      }
    }
    
    // start the thing going
    microphoneView.startListening()
  }

  
  /// called when the state changes
  func update(state: W3WVoiceViewState) {
    DispatchQueue.main.async {
      switch state {
        case .error:
          self.set(title: "Please try again", description: "", error: "Don't say street addresses,\nwe only accept what3words addresses.")

        case .idle:
          self.set(title: "Please try again", description: "e.g. \"limit broom flip\"", error: "")

        case .listening:
          self.set(title: "Say a what3words address", description: "e.g. \"limit broom flip\"", error: "")

        case .sending:
          self.set(title: "Sending", description: "e.g. \"limit broom flip\"", error: "")
      }
    }
  }
  
  
  
  
  
}

