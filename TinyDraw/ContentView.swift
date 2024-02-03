//
//  ContentView.swift
//  TinyDraw
//
//  Created by Игорь Михайлов on 01.12.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var drawing: Drawing
    @Environment(\.undoManager) var undoManager
    @State private var showingBrushOptions = false
    
    var body: some View {
        Canvas { context, size in
            for stroke in drawing.strokes {
                let path = Path(curving: stroke.points)
                
                var context = context
                
                if stroke.blur > 0 {
                    context.addFilter(.blur(radius: stroke.blur))
                }
                
                context.stroke(path, with: .color(stroke.color), style: StrokeStyle(lineWidth: stroke.width, lineCap: .round, lineJoin: .round, dash: [1, stroke.spacing * stroke.width]))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    drawing.add(point: value.location)
                }
                .onEnded { _ in
                    drawing.finish()
                }
        )
        .ignoresSafeArea()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button(action: drawing.undo) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                }
                .disabled(!(undoManager?.canUndo == true))
                
                Button(action: drawing.redo) {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                }
                .disabled(!(undoManager?.canRedo == true))
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                ColorPicker("Color", selection: $drawing.foregroundColor)
                    .labelsHidden()
                
                Button {
                    showingBrushOptions.toggle()
                } label: {
                    Image(systemName: "paintbrush.fill")
                        .foregroundStyle(.black)
                }
                
                .popover(isPresented: $showingBrushOptions) {
                    LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                        Text("Width: \(Int(drawing.lineWidth))")
                        Slider(value: $drawing.lineWidth, in: 1...100)
                        
                        Text("Softness: \(Int(drawing.blurAmount))")
                        Slider(value: $drawing.blurAmount, in: 0...50)
                        
                        Text("Spacing: \(drawing.lineSpacing, format: .percent)")
                        Slider(value: $drawing.lineSpacing, in: 0...5, step: 0.1)
                    }
                    .frame(width: 400)
                    .monospacedDigit()
                    .padding()
                }
            }
        }
        .onAppear {
            drawing.undoManager = undoManager
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Drawing())
}
