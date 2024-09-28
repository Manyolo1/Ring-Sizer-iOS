import SwiftUI

struct DialSlider: View {
    @Binding var value: CGFloat
    let bounds: ClosedRange<CGFloat>
    let majorTickCount: Int = 10
    let minorTicksPerMajor: Int = 5
    
    private var step: CGFloat {
        return (bounds.upperBound - bounds.lowerBound) / CGFloat(majorTickCount * minorTicksPerMajor)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Dial scale
                VStack(spacing: 0) {
                    ForEach(0..<(majorTickCount * minorTicksPerMajor * 2), id: \.self) { index in
                        HStack {
                            if index % minorTicksPerMajor == 0 {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 13, height: 2)
                                Spacer()
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 1)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: geometry.size.height * 2)
                .offset(y: -geometry.size.height * (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound))
                
                // Center line
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.orange)
                    .frame(width: geometry.size.width, height: 3)
                    .offset(y: geometry.size.height / 1)
                
                // Invisible drag area
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let dragPercentage = 1 - (gesture.location.y / geometry.size.height)
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * dragPercentage
                                value = min(max(newValue, bounds.lowerBound), bounds.upperBound)
                            }
                    )
            }
            .clipped()
        }
    }
}

struct ContentView: View {
    @State private var fingerSize: CGFloat = 100
    @State private var showingResult = false
    @State private var isSliderOnLeft = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("Determine ring size by\nfinger width")
                        .font(.custom("Times New Roman", size: 28))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Place your finger and adjust the slider to match its size")
                        .font(.custom("Times New Roman", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                .padding(.bottom, 30)
                
                Button(action: {
                    showingResult = true
                }) {
                    Text("Get the ring size")
                        .font(.custom("Times New Roman", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color(UIColor.darkText))
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        if isSliderOnLeft {
                            sliderAndButtons(geometry: geometry)
                                .frame(width: geometry.size.width * 0.2)
                            Spacer()
                        } else {
                            Spacer().frame(width: geometry.size.width * 0.2)
                        }
                        
                        // Finger representation (moved slightly to the right)
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: geometry.size.height * 1.4)
                                .frame(width: geometry.size.width * 0.5)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .inset(by: 8)
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(height: 100)
                                        .offset(y: -geometry.size.height * 0.65)
                                )
                                .frame(width: fingerSize, height: geometry.size.height * 1.6)
                                .offset(y: geometry.size.height * 0.3)
                        }
                        .frame(width: geometry.size.width * 0.6)
                        .clipped()
                        
                        if !isSliderOnLeft {
                            Spacer()
                            sliderAndButtons(geometry: geometry)
                                .frame(width: geometry.size.width * 0.2)
                        } else {
                            Spacer().frame(width: geometry.size.width * 0.2)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.4)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(leading: Button(action: {}) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
            .navigationBarItems(trailing: HStack(spacing: 15) {
                Button(action: {}) {
                    Text("3D")
                        .foregroundColor(.black)
                        .font(.custom("Times New Roman", size: 16))
                        .padding(8)
                        .background(Circle().stroke(Color.gray, lineWidth: 1))
                }
                Button(action: {
                    isSliderOnLeft.toggle()
                }) {
                    Image(systemName: "hand.raised")
                        .padding(8)
                        .foregroundColor(.black)
                        .background(Circle().stroke(Color.gray, lineWidth: 1))
                }
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .padding(8)
                        .foregroundColor(.black)
                        .background(Circle().stroke(Color.gray, lineWidth: 1))
                }
            })
        }
        .alert(isPresented: $showingResult) {
            Alert(title: Text("Ring Size"), message: Text("Your estimated ring size is \(calculateRingSize())"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func sliderAndButtons(geometry: GeometryProxy) -> some View {
        VStack {
            DialSlider(value: $fingerSize, bounds: 50...geometry.size.width * 0.4)
                .frame(width: 30, height: geometry.size.height * 0.35)
                .offset(y: -geometry.size.height * 0.4)
            
            VStack {
                Button(action: { fingerSize = min(fingerSize + 5, geometry.size.width * 0.4) }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }
                Button(action: { fingerSize = max(fingerSize - 5, 50) }) {
                    Image(systemName: "minus")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
    
    func calculateRingSize() -> String {
        
        let size = Int(fingerSize / 10)
        return "\(size)"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
