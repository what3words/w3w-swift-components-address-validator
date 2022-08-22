//
//  ContentView.swift
//  WatchOSAddressFinder WatchKit Extension
//
//  Created by Dave Duprey on 27/04/2022.
//

import SwiftUI
import W3WSwiftDesign
import W3WSwiftUIComponentsAddressValidator

struct ContentView: View {
  
  // the returned address if any
  @State var address: W3WStreetAddressProtocol? = nil
  
  // latest location
  @State var location: CLLocationCoordinate2D?
  
  // This keeps track of the gps coordiantes, and calls back on update
  var gps = Gps()
  
  // the color parameter in `W3WSuAddressValidator` is optional, the defaults are fine and
  // fairly neutral for almost any applicaiton, but here is how to set custom colours for
  // two of the elements.  Other colours can be set, see: `W3WSuAddressValidatorColors`
  var colors = W3WSuAddressValidatorColors(
    clearButton:   W3WTwoColor(uiForeground: UIColor.white, uiBackground: UIColor.gray),
    confirmButton: W3WTwoColor(uiForeground: UIColor.white, uiBackground: UIColor.gray))
  
  // what3words API key - get yours for free here: https://what3words.com/select-plan
  let w3wApiKey = "YourWhat3wordsApiKey"
  
  // API keys - the second parameter of the W3WAddressFinderSwiftUI constructor can take swiftCompleteApiKey, data8ApiKey, or loqateApiKey depending on which servie you would like to use
  let swiftCompleteApiKey = "YourData8ApiKey"     // Swift Complete: https://www.swiftcomplete.com
  let data8ApiKey         = "YourData8ApiKey"     // Data 8: https://www.data-8.co.uk/
  let loqateApiKey        = "YourLoqateApiKey"    // Loqate: https://www.loqate.com/

  
  var body: some View {
    
    // when the gps has new info, we update the location variable, this helper object simply
    // returns CLLocationCoordinate2D, though, probably best to use your own CoreLocation code
    gps.onUpdate = { info in
      location = info.location
    }
    
    return ZStack {
      Color.black
      
      VStack {
        Spacer()
        
        // show the component if there is no address
        if self.address == nil {
          
          // the second parameter can be `loqateApiKey`, or `data8ApiKey` to use those services instead
          W3WSuAddressValidator(w3wApiKey: w3wApiKey, swiftCompleteApiKey: swiftCompleteApiKey, coordinates: location, colors: colors) { address in
            if let a = address {
              self.address = a
            }
          }
          
        // show the address if it is available
        } else {
          
          // the returned address is of type W3WStreetAddressProtocol, all conforming addresses have a
          // `description:String`, `values: [String:Any?]`, and `words: String` members for the
          // addres, but you can check for certain types for fields that relate specifically to a
          // particular country, in thise case we check if it's the UK and then fall back onto a default
          if let a = self.address as? W3WStreetAddressUK {
            VStack {
              Text(a.words ?? "?")
              Text(a.address ?? "?")
              Text(a.street ?? "?")
              Text(a.locality ?? "?")
              Text(a.postCode ?? "?")
              Text(a.country ?? "?")
            }
            
            // this wasn't a UK address, it's probably W3WStreetAddressGeneric then, but let's just show the description
          } else {
            VStack {
              Text(self.address?.words ?? "___.___.___")
              Text(self.address?.description ?? "No result")
            }
          }
        }
        
        Spacer()
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
