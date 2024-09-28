//
//  ConverterView.swift
//  new_ring_sizer
//
//  Created by MANYA on 13/09/24.
//
import SwiftUI

struct DropdownOption: Hashable {
    let key: String
    let value: String
}

struct DropdownSelector: View {
    @Binding var selectedOption: DropdownOption
    let placeholder: String
    let options: [DropdownOption]
    @State private var isPresented = false
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            HStack {
                Text(selectedOption.value.isEmpty ? placeholder : selectedOption.value)
                    .foregroundColor(selectedOption.value.isEmpty ? .gray : .black)
                    .font(.custom("Times New Roman", size: 18))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(5)
        }
        .sheet(isPresented: $isPresented) {
            OptionListView(selectedOption: $selectedOption, options: options, isPresented: $isPresented)
        }
        Rectangle()
            .foregroundColor(.orange)
            .frame(height: 0.5)
            .frame(width: 350)
    }
}

struct OptionListView: View {
    @Binding var selectedOption: DropdownOption
    let options: [DropdownOption]
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                    isPresented = false
                }) {
                    Text(option.value)
                        .font(.custom("Times New Roman", size: 18))
                        .foregroundColor(.black)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

struct RingSize {
    let us: String
    let uk: String
    let eu: String
    let japan: String
    let china: String
}

let ringSizes: [RingSize] = [
    RingSize(us: "3", uk: "F", eu: "44", japan: "4", china: "14"),
    RingSize(us: "3.5", uk: "G", eu: "45", japan: "5", china: "14.5"),
    RingSize(us: "4", uk: "H", eu: "46", japan: "6", china: "15"),
    RingSize(us: "4.5", uk: "I", eu: "47", japan: "7", china: "15.5"),
    RingSize(us: "5", uk: "J", eu: "49", japan: "8", china: "16"),
    RingSize(us: "5.5", uk: "K", eu: "50", japan: "9", china: "16.5"),
    RingSize(us: "6", uk: "L", eu: "52", japan: "10", china: "17"),
    RingSize(us: "6.5", uk: "M", eu: "53", japan: "11", china: "17.5"),
    RingSize(us: "7", uk: "N", eu: "54", japan: "12", china: "18"),
    RingSize(us: "7.5", uk: "O", eu: "55", japan: "13", china: "18.5"),
    RingSize(us: "8", uk: "P", eu: "57", japan: "14", china: "19"),
    RingSize(us: "8.5", uk: "Q", eu: "58", japan: "15", china: "19.5"),
    RingSize(us: "9", uk: "R", eu: "59", japan: "16", china: "20"),
    RingSize(us: "9.5", uk: "S", eu: "61", japan: "17", china: "20.5"),
    RingSize(us: "10", uk: "T", eu: "62", japan: "18", china: "21"),
    RingSize(us: "10.5", uk: "U", eu: "63", japan: "19", china: "21.5"),
    RingSize(us: "11", uk: "V", eu: "65", japan: "20", china: "22"),
    RingSize(us: "11.5", uk: "W", eu: "66", japan: "21", china: "22.5"),
    RingSize(us: "12", uk: "X", eu: "67", japan: "22", china: "23"),
    RingSize(us: "12.5", uk: "Y", eu: "68", japan: "23", china: "23.5"),
    RingSize(us: "13", uk: "Z", eu: "69", japan: "24", china: "24")
]

func getStandard(for country: String) -> String {
    switch country {
    case "UNITED KINGDOM", "AUSTRALIA", "NEW ZEALAND", "IRELAND":
        return "UK"
    case "MEXICO", "CANADA", "UNITED STATES":
        return "US"
    case "ITALY", "SPAIN", "NETHERLANDS", "SWITZERLAND":
        return "EU"
    case "JAPAN", "SOUTH AMERICA", "INDIA":
        return "JAPAN"
    case "CHINA":
        return "CHINA"
    default:
        return "OTHER"
    }
}

func calculateRingSize(size: String, fromCountry: String, toCountry: String) -> String {
    let fromStandard = getStandard(for: fromCountry)
    let toStandard = getStandard(for: toCountry)
    
    guard let ringSize = ringSizes.first(where: { size == getSize(for: $0, standard: fromStandard) }) else {
        return "Unknown"
    }
    
    return getSize(for: ringSize, standard: toStandard)
}

func getSize(for ringSize: RingSize, standard: String) -> String {
    switch standard {
    case "US":
        return ringSize.us
    case "UK":
        return ringSize.uk
    case "EU":
        return ringSize.eu
    case "JAPAN":
        return ringSize.japan
    case "CHINA":
        return ringSize.china
    default:
        return ""  // china is in mm
    }
}

struct ConverterView: View {
    @State private var fromCountry = DropdownOption(key: "from_default", value: "From")
    @State private var toCountry = DropdownOption(key: "to_default", value: "To")
    @State private var ringSize = DropdownOption(key: "Your Size", value: "Your Size")
    @State private var convertedSize = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
   
    let countryOptions = [
        DropdownOption(key: "UK", value: "UNITED KINGDOM"),
        DropdownOption(key: "AU", value: "AUSTRALIA"),
        DropdownOption(key: "NZ", value: "NEW ZEALAND"),
        DropdownOption(key: "IE", value: "IRELAND"),
        DropdownOption(key: "MX", value: "MEXICO"),
        DropdownOption(key: "CA", value: "CANADA"),
        DropdownOption(key: "US", value: "UNITED STATES"),
        DropdownOption(key: "IT", value: "ITALY"),
        DropdownOption(key: "ES", value: "SPAIN"),
        DropdownOption(key: "NL", value: "NETHERLANDS"),
        DropdownOption(key: "CH", value: "SWITZERLAND"),
        DropdownOption(key: "JP", value: "JAPAN"),
        DropdownOption(key: "SA", value: "SOUTH AMERICA"),
        DropdownOption(key: "IN", value: "INDIA"),
        DropdownOption(key: "CN", value: "CHINA"),
        DropdownOption(key: "OT", value: "OTHER")
    ]
    
    var ringSizeOptions: [DropdownOption] {
        let standard = getStandard(for: fromCountry.value)
        switch standard {
        case "US":
            return ringSizes.map { DropdownOption(key: $0.us, value: $0.us) }
        case "UK":
            return ringSizes.map { DropdownOption(key: $0.uk, value: $0.uk) }
        case "EU":
            return ringSizes.map { DropdownOption(key: $0.eu, value: $0.eu) }
        case "JAPAN":
            return ringSizes.map { DropdownOption(key: $0.japan, value: $0.japan) }
        case "CHINA", "OTHER":
            return ringSizes.map { DropdownOption(key: $0.china, value: $0.china) }
        default:
            return []
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        DropdownSelector(
                            selectedOption: $fromCountry,
                            placeholder: "From",
                            options: countryOptions
                        )
                        
                        DropdownSelector(
                            selectedOption: $ringSize,
                            placeholder: "Your Size",
                            options: ringSizeOptions
                        )
                        // ! FIX  : if from and to not selected - then the list should be empty
                        
                        
                        DropdownSelector(
                            selectedOption: $toCountry,
                            placeholder: "To",
                            options: countryOptions
                        )
                        
                        Button(action: {
                            if fromCountry.value == "From" || toCountry.value == "To" || ringSize.value == "Your Size" {
                                alertMessage = "Please fill all the fields."
                                showAlert = true
                            } else {
                                convertedSize = calculateRingSize(size: ringSize.value, fromCountry: fromCountry.value, toCountry: toCountry.value)
                                if convertedSize == "Unknown" {
                                    
                                        Text("No match found.")
                                            .foregroundColor(.white)
                                            .background(Color.purple.opacity(0.4))
                                    
                                    
                                    showAlert = true
                                    convertedSize = ""
                                }
                            }
                        }) {
                            Text("Convert")
                                .frame(width: 200)
                                .padding()
                                .background(convertedSize.isEmpty ? Color.black : Color.gray.opacity(0.4))
                                .foregroundColor(convertedSize.isEmpty ? Color.white : Color.black)
                                .cornerRadius(10)
                                .font(.custom("Times New Roman", size: 20))
                        }
                        
                        if !convertedSize.isEmpty {
                            
                            HStack {
                                Text("\(toCountry.value)")
                                    .padding()
                                    .font(.custom("Times New Roman", size: 18))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                Text("\(convertedSize)")
                                    
                                    .font(.custom("Times New Roman", size: 18))
                                    .foregroundColor(.black)
                                    .padding(4)
                            }
                            .frame(width: 350)
                            .padding(5)
                            .background(Color.orange)
                            .cornerRadius(10)
                        }
                    }
                    
                    .frame(width:geometry.size.width * 0.8)
                        
                
                    Spacer()
                    
                    // TAB BAR BOTTOM
                    HStack {
                        ForEach(["Ring Sizer", "Finger Sizer", "Converter"], id: \.self) { tab in
                            TabBarButton(imageName: imageName(for: tab), text: tab)
                                .padding()
                        }
                    }
                    .foregroundColor(.black)
                    .padding(.bottom, -10)
                }
                .frame(width: geometry.size.width)
                .navigationBarItems(leading:
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                )
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func imageName(for tab: String) -> String {
        switch tab {
        case "Ring Sizer":
            return "checkmark.circle"
        case "Finger Sizer":
            return "hand.tap"
        case "Converter":
            return "arrow.right.arrow.left"
        default:
            return ""
        }
    }
}

struct TabBarButton: View {
    let imageName: String
    let text: String
    
    var body: some View {
        Button(action: {}) {
            VStack {
                Image(systemName: imageName)
                Text(text)
            }
        }
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
    }
}
