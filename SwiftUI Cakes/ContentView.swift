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
    
    func update() {
         didChange.send()
    }
}

struct ContentView : View {
    @ObjectBinding var order = Order()
    
    var body: some View {
        NavigationView{
            Form {
                Picker(selection: $order.type, label: Text("Select your cake type")) {
                    ForEach(0 ..< Order.types.count) {
                        Text(Order.types[$0]).tag($0)
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
