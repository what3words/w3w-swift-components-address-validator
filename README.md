# <img valign='top' src="https://what3words.com/assets/images/w3w_square_red.png" width="32" height="32" alt="what3words">&nbsp;w3w-swift-components-address-validator

Overview
--------

This package provides components to help your user find an old fashioned street address from a three word address.

There is an iOS UIKit component and a watchOS SwiftUI component

### UIKit

The UIKit version is `W3WSuAddressValidator`. It is derived from a `UIViewController`.  Simply instantiate it and present it on your view stack, preferably in a popup modal view.

```Swift

var api  = What3WordsV3(apiKey: apiKey)

let validator = W3WAddressValidatorViewController(w3w: api, swiftCompleteApiKey: "yourSwiftCompleteApiKey")

// set the focus to a nearby location
let options = W3WOptions().focus(gpsLocation)
validator.set(options: options)

// present the view controller
show(validator, sender: self)

// closure for when the address has been selected by the user
validator.onAddressSelected = { address in
  print(address.description)
}

```

### SwiftUI

The SwiftUI version takes the various service API keys and also a completion block for the results:

```Swift

// body of the view
var body: some View {
  
  W3WSuAddressValidator(w3wApiKey: "YourWhat3wordsApiKey, swiftCompleteApiKey: "yourSwiftCompleteApiKey", coordinates: location) { address in
    print(address.description)
  }
  
}

```

