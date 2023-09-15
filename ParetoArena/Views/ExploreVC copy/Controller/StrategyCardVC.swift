//
//  StrategyCarousel.swift
//  Pareto
//
//  Created by Zachary Coriarty on 4/15/23.
//

import SwiftUI

struct StrategyCardVC: View {
    @StateObject private var viewModel = StrategyCardViewModel()
    @State private var sortOption: SortOption = .risk
    @State private var filterCategory: String?
    @State private var showStrategyDescription: Bool = false
    @State private var currentCard: StrategyCard?

    var filteredCards: [StrategyCard] {
        viewModel.cards.filter { card in
            filterCategory == nil || card.category == filterCategory
        }.sorted(by: sortOption.sortFunction)
    }

    var categories: [String] {
        Array(Set(viewModel.cards.map { $0.category })).sorted()
    }

    
    enum SortOption: CaseIterable {
        case risk
        case category

        var title: String {
            switch self {
            case .risk:
                return "Sort by Risk"
            case .category:
                return "Filter by Category"
            }
        }

        func sortFunction(_ card1: StrategyCard, _ card2: StrategyCard) -> Bool {
            switch self {
            case .risk:
                return card1.risk < card2.risk
            case .category:
                return card1.category < card2.category
            }
        }
    }

    var body: some View {
        VStack {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    CapsuleView(title: "All Categories", backgroundColor: Color.blue.opacity(0.3)) {
//                        filterCategory = nil
//                    }.foregroundColor(.blue)
//
//                    ForEach(categories, id: \.self) { category in
//                        let cardColor = StrategyCard.categoryColor(for: category)
//                        CapsuleView(title: category, backgroundColor: cardColor.opacity(0.3)) {
//                            filterCategory = filterCategory == category ? nil : category
//                        }.foregroundColor(cardColor)
//                    }
//                }.padding(.horizontal)
//                }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filteredCards) { card in
                        CardView(card: card)
                            
                    }
                }.padding(.horizontal)
            }
        }.onAppear {
            viewModel.fetchCards()
        }
        
    }
}


struct CardView: View {
    let card: StrategyCard
    @State private var presentBacktest: Bool = false
    @State private var showDescription: Bool = false
    // Dummy data for the line graph
    let graphData: [Double] = [50, 30, 60, 20, 80, 10, 90]

    var body: some View {
        Button(action: {
            presentBacktest = true
        }){
            VStack {
                HStack {
                    Text(card.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(.leading)
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        Button(action: {
                            showDescription = true
                        }) {
                            Text("Learn")
                                .foregroundColor(Color.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.tertiarySystemGroupedBackground))
                                .cornerRadius(10)
                                
                        }
                        
                        
                    }
                    
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        CapsuleView(title: "Risk: \(card.risk)/10", backgroundColor: card.riskColor.opacity(0.3), titleSize: 10)
                            .foregroundColor(card.riskColor)
                        CapsuleView(title: card.category, backgroundColor: card.cardColor.opacity(0.3), titleSize: 10)
                            .foregroundColor(card.cardColor)
                        
                        Text(card.author)
                            .font(.footnote)
                            .foregroundColor(Color.secondary.opacity(0.9))
                    }
                }
                .padding([.leading, .trailing, .bottom])
                
            }
            .padding([.top])
            .frame(width: 290, height: 150)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(radius: 0.5)
        }
        .sheet(isPresented: $showDescription) {
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.system(size: 35, weight: .bold))
                    .padding(.bottom)
                Text(card.description)
                    .font(.callout)
            }
            .padding()
        }
        .sheet(isPresented: $presentBacktest) {
            if #available(iOS 16.0, *) {
                NewBacktestSheetView(strategy: card.name)
                    .presentationDetents([.medium])
            } else {
                NewBacktestSheetView()
            }
        }
    }
}

extension StrategyCard {
    static func categoryColor(for category: String) -> Color {
        return Color.blue // All categories are the same color: blue.
    }

    var riskColor: Color {
        let riskValue = (Double(risk) ?? 0) / 10.0
        let hue = 0.4 * (1 - riskValue)
        return Color(hue: hue, saturation: 1, brightness: 0.75)
    }
}



struct CapsuleView: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    let titleSize: Int
    
    init(title: String, backgroundColor: Color, action: (() -> Void)? = nil, titleSize: Int? = 12) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action ?? {}
        self.titleSize = titleSize ?? 12
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: CGFloat(titleSize), weight: .semibold))
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(backgroundColor))
        }
    }
}






class StrategyCardViewModel: ObservableObject {
    @Published var cards: [StrategyCard] = []
    
    func fetchCards() {
        let endpoint = EndPoint.sServerBase + EndPoint.strategies
        guard let url = URL(string: endpoint) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([StrategyCard].self, from: data)
                DispatchQueue.main.async {
                    self.cards = decodedData
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct StrategyCard: Decodable, Identifiable, Hashable {
    var id: UUID
    let name: String
    let author: String
    let category: String
    let description: String
    let risk: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case author = "Author"
        case category = "Category"
        case description = "Description"
        case risk = "Risk"
    }
}
extension StrategyCard {
    var cardColor: Color {
        switch category {
        case "Technical Analysis":
            return Color(hex: "#0077B5") // blue
        case "Trend Following":
            return Color(hex: "#00743F") // green
        case "Volatility":
            return Color(hex: "#FFC107") // yellow
        case "Price Action":
            return Color(hex: "#FF5722") // orange
        case "Pattern Recognition":
            return Color(hex: "#C2185B") // purple
        default:
            return Color(hex: "#757575") // gray
        }
    }
}

//extension StrategyCard {
//    static func categoryColor(for category: String) -> Color {
//        switch category {
//        case "Technical Analysis":
//            return Color(hex: "#0077B5") // blue
//        case "Trend Following":
//            return Color(hex: "#00743F") // green
//        case "Volatility":
//            return Color(hex: "#FFC107") // yellow
//        case "Price Action":
//            return Color(hex: "#FF5722") // orange
//        case "Pattern Recognition":
//            return Color(hex: "#C2185B") // purple
//        default:
//            return Color(hex: "#757575") // gray
//        }
//    }
//
//    var riskColor: Color {
//        let riskValue = (Double(risk) ?? 0) / 10.0
//        let hue = 0.4 * (1 - riskValue)
//        return Color(hue: hue, saturation: 1, brightness: 0.75)
//    }
//}


struct StrategyCardVC_Previews: PreviewProvider {
    static var previews: some View {
        StrategyCardVC()
    }
}

