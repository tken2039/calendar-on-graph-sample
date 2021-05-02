//
//  ContentView.swift
//  calendar-component
//
//  Created by tken on 2021/04/25.
//

import SwiftUI

func generateCGFloat(count: Int) -> [CGFloat] {
    var array: [CGFloat] = []
    for _ in 0..<count {
        array.append(CGFloat.random(in: 0...100))
    }
    
    return array
}

struct ContentView: View {
    let nomalizeStatus = generateCGFloat(count: 35).map { $0 * 0.4 }
    let columns = Array(repeating: GridItem(.flexible(minimum: 42), spacing: 0), count: 7)
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                LazyVGrid(columns: columns, spacing: 0, content: {
                    ForEach((0...nomalizeStatus.count-1), id: \.self) { index in
                        if index == 0 {
                            RectangleWithStatusGraph(status: Array(nomalizeStatus[index ... index+1]), start: true)
                        } else if index < nomalizeStatus.count-1 {
                            RectangleWithStatusGraph(status: Array(nomalizeStatus[index-1 ... index+1]))
                        } else {
                            RectangleWithStatusGraph(status: Array(nomalizeStatus[index-1 ... index]), end: true)
                        }
                    }
                })
                .padding(.horizontal, 10)
                .frame(maxWidth: geo.size.width)
                .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct RectangleWithStatusGraph: View {
    
    let status: [CGFloat]
    var start: Bool = false
    var end: Bool = false
        
    var body: some View {
        Rectangle()
            .frame(height: 100)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(Color.white)
            .border(Color.gray)
            .overlay(
                VStack(spacing: 0){
                    GeometryReader { geo in
                        StrokeBasedStatus(fieldWidth: geo.size.width, fieldHeight: geo.size.height, status: status, start: self.start, end: self.end)
                    }
                }
            )
    }
}

struct StrokeBasedStatus: View {
    
    let fieldWidth: CGFloat
    let fieldHeight: CGFloat
    let status: [CGFloat]
    let start: Bool
    let end: Bool
    
    let pointSize: CGFloat = 6
    let circleLineWidth: CGFloat = 2
    let statusLineWidth: CGFloat = 2
        
    var body: some View {
        ZStack {
            Path { path in
                if start {
                    path.addLines([
                        CGPoint(x: fieldWidth/2, y: status[0]),
                        CGPoint(x: fieldWidth, y: (status[0] + status[1])/2)
                    ])
                } else if end {
                    path.addLines([
                        CGPoint(x: 0, y: (status[0]+status[1])/2),
                        CGPoint(x: fieldWidth/2, y: status[1])
                    ])
                } else {
                    path.addLines([
                        CGPoint(x: 0, y: (status[0]+status[1])/2),
                        CGPoint(x: fieldWidth/2, y: status[1])
                    ])
                    path.addLines([
                        CGPoint(x: fieldWidth/2, y: status[1]),
                        CGPoint(x: fieldWidth, y: (status[1] + status[2])/2)
                    ])
                }
            }
            .stroke(lineWidth: statusLineWidth)
            .foregroundColor(Color.green)
            
            VStack {
                GeometryReader { geometry in
                    Circle()
                        .stroke(Color.green, lineWidth: circleLineWidth)
                        .background(Color.white)
                        .frame(width: pointSize, height: pointSize)
                        .offset(x: (fieldWidth/2)-(pointSize/2), y: start ? status[0]-(pointSize/2) : status[1]-(pointSize/2))
                }
            }
        }
        .offset(x: 0, y: fieldHeight/7)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
