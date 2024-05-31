import Foundation
import UIKit
import SwiftUI
import RealmSwift

struct Category{
    var categoryName: String = ""
    var categoryType:String = ""
    var icon : String = ""
    var color: Color = .clear
    
    var expenseCategories = ["Car","Food","Bank","Charity","Children","House","Pets","Health","Beauty","Mobile Connection","Education","Clothing and Footwear","Gift","Grocery","Entertainment","Travel"]
    var incomeCategories = ["Rent","Exchange","Dividends","Wage","Present","Part time job","Interest on accounts"]
    
}
let categoryInfo : [String : Category] = [
                                          
    // Expense category
    "Car" : Category(categoryName : "Car",categoryType: "expense", icon: "car.fill",color: Color.teal),
    "Food" : Category(categoryName : "Food",categoryType: "expense", icon: "fork.knife",color: Color.yellow),
    "Bank" : Category(categoryName : "Bank",categoryType: "expense",icon: "creditcard.circle.fill",color: Color.yellow),
    "Charity" : Category(categoryName : "Charity",categoryType: "expense",icon: "person.2",color: Color.green),
    "Children" : Category(categoryName : "Children",categoryType: "expense",icon: "figure.2.and.child.holdinghands",color: Color.cyan),
    "House" : Category(categoryName : "House",categoryType: "expense",icon: "house",color: Color.orange),
    "Pets" : Category(categoryName : "Pets",categoryType: "expense",icon: "fish",color: Color.yellow),
    "Health" : Category(categoryName : "Health",categoryType: "expense",icon: "heart",color: Color.red),
    "Beauty" : Category(categoryName : "Beauty",categoryType: "expense",icon: "fleuron",color: Color.orange),
    "Mobile Connection" : Category(categoryName : "Mobile Connection",categoryType: "expense",icon: "wifi",color: Color.blue),
    "Education" : Category(categoryName : "Education",categoryType: "expense",icon: "book",color: Color.indigo),
    "Clothing and Footwear" : Category(categoryName : "Clothing and Footwear",categoryType: "expense",icon: "backpack",color: Color.brown),
    "Gift" : Category(categoryName : "Gift",categoryType: "expense",icon: "gift",color: Color.purple),
    "Grocery" : Category(categoryName : "Grocery",categoryType: "expense", icon: "cart.fill",color: Color.green),
    "Entertainment" : Category(categoryName : "Entertainment",categoryType: "expense",icon: "music.mic",color: Color.pink),
    "Travel" : Category(categoryName : "Travel",categoryType: "expense", icon: "tram.fill",color: Color.orange),


    //Income categories
                                          
    "Rent" : Category(categoryName : "Rent",categoryType: "income", icon: "key",color: Color.teal),
    "Exchange" : Category(categoryName : "Exchange",categoryType: "income", icon: "arrow.triangle.2.circlepath",color: Color.orange),
    "Dividends" : Category(categoryName : "Dividends",categoryType: "income", icon: "chart.xyaxis.line",color: Color.yellow),
    "Wage" : Category(categoryName : "Wage",categoryType: "income", icon: "dollarsign",color: Color.green),
    "Present" : Category(categoryName : "Present",categoryType: "income", icon: "shippingbox.circle",color: Color.mint),
    "Part time job" : Category(categoryName : "Part time job",categoryType: "income", icon: "person.fill.checkmark",color: Color.red),
    "Interest on accounts" : Category(categoryName : "Interest on accounts",categoryType: "income", icon: "percent",color: Color.pink)]

