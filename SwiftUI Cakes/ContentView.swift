//
//  ContentView.swift
//  SwiftUI Cakes
//
//  Created by Wissa Azmy on 6/19/19.
//  Copyright © 2019 Wissa Michael. All rights reserved.
//

import SwiftUI
import Combine

class Order: BindableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case type, quantity, extraFrosting, extraSprinkles, name, address, city, zip
    }
    
    var didChange = PassthroughSubject<Void, Never>()
    static let types = ["Vanilla", "Nova", "Chocolate"]
    
    var type = 0 { didSet { update() } }
    var quantity = 3 { didSet { update() }}
    var extraFrosting = false { didSet { update() }}
    var extraSprinkles = false { didSet { update() }}
    var specialRequestsEnabled = false { didSet { update() }}
    
    var name = "" { didSet { update() }}
    var address = "" { didSet { update() }}
    var city = "" { didSet { update() }}
    var zip = "" { didSet { update() }}
    
    var isValid: Bool {
        if name.isEmpty || address.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    func update() {
         didChange.send()
    }
}


struct ContentView : View {
    @ObjectBinding var order = Order()
    @State var confiramtionMessage = ""
    @State var showingConfiramtion = false
    
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
                
                Section {
                    TextField($order.name, placeholder: Text("Name"))
                    TextField($order.address, placeholder: Text("Street Address"))
                    TextField($order.city, placeholder: Text("City"))
                    TextField($order.zip, placeholder: Text("Zip"))
                }
                
                Section {
                    Button(action: {
                        self.placeOrder()
                    }) {
                        Text("Place Order")
                    }
                }.disabled(!order.isValid)
            }
                
            .navigationBarTitle(Text("Cupcake Corner"))
            .presentation($showingConfiramtion) {
                Alert(title: Text("Thank you!"), message: Text(confiramtionMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func placeOrder() {
        guard let encodedOrderData = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedOrderData
        
        URLSession.shared.dataTask(with: request) {
            guard let data = $0 else {
                print("No data in response: \($2?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confiramtionMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfiramtion = true
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Invalid response: \(dataString)")
            }
        }.resume()
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
