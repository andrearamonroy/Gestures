//
//  ContentView.swift
//  Gestures
//
//  Created by Andrea Monroy on 1/6/23.
//

import SwiftUI

//MagnificationGesture
struct ContentView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                    }
        //so it gets bigger and bigger (it scales)
                    .scaleEffect(finalAmount + currentAmount)
                    .gesture(
                        //on itself it doesnt do anything but with .onChanged closure and .onEnded closure it does
                        MagnificationGesture()
                        //adds action to perform when the gesture's value changes, it will tell us what the new amount is
                            .onChanged({ amount in
                            currentAmount = amount - 1
                        })
                        .onEnded({ amount in
                            //scale
                            finalAmount += currentAmount
                            //release
                            currentAmount = 0
                        })
                    )
        }
    }
    
//option B to test in simulator
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
}

//RotationGesture
struct RotationView: View {
    @State private var currentAmount =  Angle.zero
    @State private var finalAmount = Angle.zero
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                    }
                    .rotationEffect(currentAmount + finalAmount)
                    .gesture(
                        RotationGesture()
                        .onChanged({ angle in
                            currentAmount = angle
                        })
                        .onEnded({ angle in
                            finalAmount += currentAmount
                            currentAmount = .zero
                        })
                    )
        }
    }
    
    struct RotationView_Previews: PreviewProvider {
        static var previews: some View {
            RotationView()
        }
}

//HighPriorityGesture
//Parent-Child gestures

struct HighPriorityGestureView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            //child gesture
                .onTapGesture {
                    print("Text tapped!")
                }
            //parent gesture
                .highPriorityGesture(
                TapGesture()
                //action when gesture ends
                    .onEnded({ print("tapped")
                    })
                )
        }
        
    }
    
    struct HighPriorityGestureView_Previews: PreviewProvider {
        static var previews: some View {
            HighPriorityGestureView()
        }
    }
}

//SequenceGestures = A has to happen then B will happen (you reference each other)
struct SequenceGestureView: View {
    //state for how far the circle has been dragged
    @State private var offset = CGSize.zero
    //State to see if its been dragged right now or not
    @State private var isDragging = false
    
    var body: some View {
        //dragging motion that involves an action-sequence
        let dragGesture = DragGesture()
            .onChanged { value in
                //translation: translation from the start of the drag gesture to the current event of grad gesture
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        
        let pressedGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combine = pressedGesture.sequenced(before: dragGesture)
        
     
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
        //grow from 1 to 1.5 on the screen to symbolized is being dragged
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combine)
    }
    
    struct SequenceGestureView_Previews: PreviewProvider {
        static var previews: some View {
            SequenceGestureView()
        }
    }
}
