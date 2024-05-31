import SwiftUI

struct currencyConversion: View {
    @State var baseCurrencyNumber : Float = 0
    @State var baseCurrency: Currency = .usd
    @State var newCurrencyNumber : Float = 0
    @State var newCurrency: Currency = .inr
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 5
        formatter.zeroSymbol = ""
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    private let formatter2: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 5
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("colorBG")
                VStack{
                    Spacer()
                    Text("Currency Conversion")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .frame(width:330,alignment: .leading)
                        .padding(.bottom,10)
                    HStack{
                        TextField("Amount",value: $baseCurrencyNumber, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: 230, maxHeight: 60)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                            .padding(.bottom, 15)
                        Picker("Currency", selection: $baseCurrency) {
                            ForEach(Currency.sortedCases, id: \.self) { currency in
                                Text(currency.rawValue + "(\(currency.symbol))")
                                    .tag(currency)
                            }
                        }
                        .padding(.vertical)
                        .frame(maxWidth: 100, maxHeight: 60)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                        .padding(.bottom, 15)
                        
                    }
                    HStack{
                        TextField("Converted Amount",value: $newCurrencyNumber, formatter: formatter2)
                            .disabled(true)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: 230, maxHeight: 60)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                            .padding(.bottom, 15)
                        Picker("Currency", selection: $newCurrency) {
                            ForEach(Currency.sortedCases, id: \.self) { currency in
                                Text(currency.rawValue + "(\(currency.symbol))")
                                    .tag(currency)
                            }
                        }
                        .padding(.vertical)
                        .frame(maxWidth: 100, maxHeight: 60)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                        .padding(.bottom, 15)
                        
                    }
                    Button(action: {
                        performRequest(from: baseCurrency.id, to: newCurrency.id, amount: baseCurrencyNumber) { amount, error in
                            if let error = error {
                                print("Error: \(error)")
                            } else if let amount = amount {
                                print("Amount: \(amount)")
                                newCurrencyNumber = amount
                            }
                        }
                    }, label: {
                        Text("Convert")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                    })
                    .padding(.vertical)
                    .frame(maxWidth: 335, maxHeight: 60)
                    .background(Color.pink)
                    .cornerRadius(10)
                    .padding(.bottom, 15)
                    Spacer()
                }
            }
            .background(Color("colorBG"))
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    func performRequest(from: String , to: String , amount : Float,completion: @escaping (Float?, Error?) -> Void) {
        let baseurl = "https://api.fxratesapi.com/convert?from=\(from)&to=\(to)&amount=\(amount)"
        if let url = URL(string: baseurl) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let safeData = data {
                    let amount = parseJSON(amount: safeData)
                    completion(amount, nil)
                } else {
                    completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
                }
            }
            
            task.resume()
        } else {
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
        }
    }
    func parseJSON(amount : Data) -> Float
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData=try decoder.decode(AmountModel.self, from: amount)
            let finalAmount = decodedData.result
            return finalAmount
        }
        catch
        {
            return 0
        }
    }
            
}

#Preview {
    currencyConversion()
}
