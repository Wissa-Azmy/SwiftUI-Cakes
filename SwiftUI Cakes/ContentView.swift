//
//  ContentView.swift
//  SwiftUI Cakes
//
//  Created by Wissa Azmy on 6/19/19.
//  Copyright © 2019 Wissa Michael. All rights reserved.
//

import SwiftUI
import Combine

class Order: BindableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    static let types = ["Vanilla", "Nova", "Chocolate"]
    var type = 0 { didSet { update() } }
    var quantity = 3 { didSet { update() }}
    var extraFrosting = false { didSet { update() }}
    var extraSprinkles = false { didSet { update() }}
    var specialRequestsEnabled = false { didSet { update() }}
    
    func update() {
         didChange.send()
    }
}

struct ContentView : View {
    @ObjectBinding var order = Order()
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker(selection: $order.type, label: Text("Select your cake type")) {
                        ForEach(0 ..< Order.types.count) {
                            Text(Order.types[$0]).tag($0)
                        }
                    }
                    
                    Stepper(value: $order.quantity) {
                        Text("Number of cakes: \(order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.specialRequestsEnabled) {
                        Text("Do you have special request?")
                    }
                    
                    if order.specialRequestsEnabled {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add Extra Frosting")
                        }
                        Toggle(isOn: $order.extraSprinkles) {
                            Text("Add Extra Sprinkles")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Cupcake Corner"))
        }
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
