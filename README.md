# <img valign='top' src="https://what3words.com/assets/images/w3w_square_red.png" width="32" height="32" alt="what3words">&nbsp;w3w-swift-components-address-validator

Overview
--------

This package provides components to help your user find an old fashioned street address from a three word address by connecting with 3rd party address validation services.  It supports [Loqate](https://www.loqate.com/), [Data8](https://www.data-8.co.uk), and [Swift Complete](https://www.swiftcomplete.com).

There is an iOS UIKit component and a watchOS SwiftUI component.

When installing the Swift Package you can choose either or both of:

* `W3WSwiftComponentsAddressValidator`
* `W3WSwiftUIComponentsAddressValidator`

Notice the first one is prefixed with `W3WSwift` and the second `W3WSwiftUI`.  The first one uses UIKit and works on iOS, iPadOS, and macCatalyst.  The second is designed for watchOS and is written in SwiftUI.

##### Choosing a service

Create an account with either [Loqate](https://www.loqate.com/), [Data8](https://www.data-8.co.uk), or [Swift Complete](https://www.swiftcomplete.com) and get an API key from them.

When instantiating the component for UIKit or SwiftUI the second parameter takes the key sets the service.  Use the appropriate parameter and label:

* For Data8 use: `data8ApiKey: String`
* For Swift Complete use: `swiftCompleteApiKey: String`
* For Loqate use: `loqateApiKey: String`

##### what3words

If you use this component you will also need a what3words API key.  This is to enable the voice input and what3words autosuggest.  If you only want to use an address validator service you can use our Address Validator wrapper [(w3w-swift-address-validators)](https://github.com/what3words/w3w-swift-address-validators) instead and build out your own UI interface.  The wrapper takes a three word address as input and doesn't need voice or autosuggest support.  This package has a dependancy on that wrapper.

### UIKit

The UIKit version is `W3WSuAddressValidator`. It is derived from a `UIViewController`.  Simply instantiate it and present it on your view stack, preferably in a popup modal view.

```Swift

var api  = What3WordsV3(apiKey: "YourWhat3wordsApiKey")

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

### SwiftUI (watchOS)

##### Example

An example can be found in [/Examples/WatchOS/WatchOSAddressValidator.xcodeproj](Examples/WatchOS/WatchOSAddressValidator.xcodeproj)

##### Overview

The watchOS SwiftUI version takes the various service API keys and also a completion block for the results:

```Swift

// body of the view
var body: some View {
  
  W3WSuAddressValidator(w3wApiKey: "YourWhat3wordsApiKey, swiftCompleteApiKey: "yourSwiftCompleteApiKey", coordinates: location) { address in
    print(address.description)
  }
  
}

```

