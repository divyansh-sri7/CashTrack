import SwiftUI
import FirebaseAuth
import Charts
import Firebase


struct HomeScreen: View{
    
    //MARK: - Variables
    
    @Environment(\.colorScheme) var colorScheme
    @State var selectedPicker:String = "Expenses"
    @State var chartPicker:String = "Pie"
    @State var showAddTransaction = false
    @State var showExpenseTransactions = false
    @State var showIncomeTransactions = false
    @State var selectedCategoryType: CategoryType = .expense
    @ObservedObject var transactionVM:transactionData = transactionData()
    
    //MARK: - View
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing:10){
                        
                        
                        
                        //MARK: - top 4 blocks
                        
                        HStack(spacing:10){
                            top4blocks(imageTitle: "plus.circle.fill", moneytext: String(format: "%.2f",transactionVM.incomes()), blocktitle: "INCOME", iconColor: Color.green)
                            top4blocks(imageTitle: "equal.circle.fill", moneytext: String(format: "%.2f",transactionVM.balanceTotal()), blocktitle: "BALANCE", iconColor: Color.cyan)
                        }
                        HStack(spacing:10){
                            top4blocks(imageTitle: "minus.circle.fill", moneytext: String(format: "%.2f",transactionVM.expenses()), blocktitle: "EXPENSE", iconColor: Color.red)
                            top4blocks(imageTitle: "plusminus.circle.fill", moneytext: String(format: "%.2f",transactionVM.expenseAvg()), blocktitle: "EXPENSE AVERAGE", iconColor: Color.orange)
                        }
                        
                        //MARK: - picker
                        
                        ZStack {
                            BackgroundRect(width: 370, height: 60)
                            Picker("Choose the picker",selection: $selectedPicker){
                                Text("Expenses")
                                    .tag("Expenses")
                                Text("Income")
                                    .tag("Income")
                            }
                            .pickerStyle(.segmented)
                            .padding()
                        }
                        
                        //MARK: - expenses picker
                        
                        if selectedPicker == "Expenses" {
                            Button(action: {
                                showExpenseTransactions.toggle()
                            }, label: {
                                ZStack {
                                    BackgroundRect(width: 370, height: 370)
                                    if transactionVM.numberOfExpenseTransactions()==0{
                                        Text("--No Data--")
                                            .font(.system(size: 40))
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.primary)
                                            .opacity(0.5)
                                    }
                                    else{
                                        VStack {
                                            TabView {
                                                Chart {
                                                    let groupedTransactions = Dictionary(grouping: transactionVM.transactions.filter { $0.categoryType == .expense }, by: { $0.category })
                                                        .mapValues { $0.reduce(0) { $0 + $1.amount } }
                                                    
                                                    ForEach(groupedTransactions.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                                                        SectorMark(angle: .value("Amount", amount), innerRadius: .ratio(0.618), angularInset: 1.5)
                                                            .foregroundStyle(by: .value("Category", category))
                                                            .cornerRadius(4)
                                                    }
                                                }
                                                
                                                .padding(.bottom)
                                                .chartLegend(alignment:.bottom,spacing:20)
                                                .frame(width: 300,height: 300)
                                                Chart {
                                                    let groupedTransactions = Dictionary(grouping: transactionVM.transactions.filter { $0.categoryType == .expense }, by: { $0.category })
                                                        .mapValues { $0.reduce(0) { $0 + $1.amount } }

                                                    ForEach(groupedTransactions.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                                                        BarMark(x: .value("Category", category), y: .value("Amount", amount))
                                                            .foregroundStyle(by: .value("Category", category))
                                                            .cornerRadius(4)
                                                    }
                                                }
                                                
                                                .padding(.bottom)
                                                .chartLegend(alignment:.bottom,spacing:20)
                                                .frame(width: 300,height: 300)
                                                
                                            }
                                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                                        }
                                    }
                                }
                            })
                        }
                        
                        
                    //MARK: - income picker
                    
                    if selectedPicker=="Income"{
                        Button(action: {
                            showIncomeTransactions.toggle()
                        }, label: {
                            ZStack {
                                BackgroundRect(width: 370, height: 370)
                                if transactionVM.numberOfIncomeTransactions()==0{
                                    Text("--No Data--")
                                        .font(.system(size: 40))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.primary)
                                        .opacity(0.5)
                                }
                                else{
                                    VStack {
                                        TabView {
                                            Chart {
                                                let groupedTransactions = Dictionary(grouping: transactionVM.transactions.filter { $0.categoryType == .income }, by: { $0.category })
                                                    .mapValues { $0.reduce(0) { $0 + $1.amount } }
                                                
                                                ForEach(groupedTransactions.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                                                    SectorMark(angle: .value("Amount", amount), innerRadius: .ratio(0.618), angularInset: 1.5)
                                                        .foregroundStyle(by: .value("Category", category))
                                                        .cornerRadius(4)
                                                }
                                            }
                                            .padding(.bottom)
                                            .chartLegend(alignment:.bottom,spacing:20)
                                            .frame(width: 300,height: 300)
                                            Chart {
                                                let groupedTransactions = Dictionary(grouping: transactionVM.transactions.filter { $0.categoryType == .income }, by: { $0.category })
                                                    .mapValues { $0.reduce(0) { $0 + $1.amount } }
                                                
                                                ForEach(groupedTransactions.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                                                    BarMark(x: .value("Category", category), y: .value("Amount", amount))
                                                        .foregroundStyle(by: .value("Category", category))
                                                        .cornerRadius(4)
                                                }
                                            }
                                            .padding(.bottom)
                                            .chartLegend(alignment:.bottom,spacing:20)
                                            .frame(width: 300,height: 300)
                                            
                                        }
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                                    }
                                }
                            }

                        })
                    }
                        ZStack {
                            switch(transactionVM.transactions.count){
                            case 1:
                                BackgroundRect(width: 370, height: 200)
                            case 2:
                                BackgroundRect(width: 370, height: 300)
                            default:
                                BackgroundRect(width: 370, height: 400)
                            }
                            VStack {
                                HStack {
                                    Text("Transactions")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(.top,20)
                                .padding(.leading,30)
                                Divider()
                                if transactionVM.transactions.count == 0{
                                    Spacer()
                                }
                                ForEach(transactionVM.recentTransactions()) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                                .padding(.horizontal,30)
                                Divider()
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: allTransactions()) {
                                        Text("Show more")
                                    }
                                    Spacer()
                                }
                                .padding(.top,5)
                                .padding(.bottom,15)
                                
                            }
                        }
                }
            }
                
                
                //MARK: - toolbar
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                            Button{} label: {
                                NavigationLink(destination: MenuView()) {
                                    Text("Menu")
                                        .font(.title3)
                                        .foregroundStyle(Color.blue)
                                }
                            }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("CashTrack")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                }
            .padding()
                HStack {
                    Button {
                        showAddTransaction.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color.primary)
                            Image(systemName: "plus")
                                .foregroundColor(colorScheme == .light ? Color("colorBG") : Color.black)
                                .font(.system(size: 30))
                        }
                    }
                }
                .padding(.all, 25)
            }
            .background(Color("colorBG"))
            .onAppear(){
                transactionVM.fetchData()
            }
        }
        .onAppear(){
            transactionVM.fetchData()
        }
        //MARK: - sheets
        
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView()
                .onDisappear(){
                    transactionVM.fetchData()
                }
        }
        .onAppear(){
            transactionVM.fetchData()
        }
        .sheet(isPresented: $showExpenseTransactions){
            ExpensesTransactions()
        }
        .onAppear(){
            transactionVM.fetchData()
        }
        .sheet(isPresented: $showIncomeTransactions){
            IncomeTransactions()
        }
    }
}
private struct TransactionRow: View {
    var transaction: transactionModel

    var body: some View {
        VStack {
            HStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(categoryInfo[transaction.category]?.color ?? Color.gray)
                    Image(systemName: categoryInfo[transaction.category]!.icon)
                        .foregroundStyle(Color.white)
                }
                Text(transaction.category)
                Spacer()
                Text(transaction.categoryType == .expense ? "-"+String(format: "%.2f", transaction.amount) : "+"+String(format: "%.2f", transaction.amount))
                    .foregroundStyle(transaction.categoryType == .expense ? Color.red : Color.green)
            }
            HStack{
                Text("Date : ")
                Text(formattedDate(transaction.date))
                Spacer()
            }
            HStack{
                Text("Note : ")
                Text(transaction.note)
                Spacer()
            }
        }
    }
}

private func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: date)
}

//MARK: - preview

#Preview {
    HomeScreen()
}

//MARK: - subview

struct BackgroundRect: View {
    @Environment(\.colorScheme) var colorScheme
    var width:CGFloat
    var height:CGFloat
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
            .fill(colorScheme == .light ? .white : .gray)
            .frame(width: width,height: height)
            .opacity(colorScheme == .light ? 1 : 0.15)
    }
}

struct top4blocks: View {
    var imageTitle:String
    var moneytext:String
    var blocktitle:String
    var iconColor:Color
    var body: some View {
        ZStack{
            BackgroundRect(width: 180, height: 100)
            VStack(alignment: .leading,spacing: 10){
                HStack{
                    Image(systemName: imageTitle)
                        .foregroundStyle(iconColor)
                        .font(.system(size:30))
                    Spacer()
                    Text(moneytext)
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                    Spacer()
                }
                Text(blocktitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                    .fontWeight(.regular)
            }
            .frame(width: 180)
            .offset(x:15)
        }
    }
}
