//
//  ContentView.swift
//  SwiftUIAppStore
//
//  Created by Simon Ng on 10/9/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var showContents: [Bool] = Array(repeating: false, count: sampleArticles.count)
    
    enum ContentMode {
        case list
        case content
    }
    
    private var contentMode: ContentMode {
        self.showContents.contains(true) ? .content : .list
    }
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                VStack(spacing: 40) {
                    TopBarView()
                        .padding(.horizontal, 20)
                        .opacity(self.contentMode == .content ? 0 : 1)
                    
                    ForEach(sampleArticles.indices) { index in
                        GeometryReader { inner in
                            ArticleCardView(
                                category: sampleArticles[index].category,
                                headline: sampleArticles[index].headline,
                                subHeadline: sampleArticles[index].subHeadline,
                                image: sampleArticles[index].image,
                                content: sampleArticles[index].content,
                                isShowContent: self.$showContents[index]
                            )
                            .offset(y: self.showContents[index] ? -inner.frame(in: .global).minY : 0)
                            .padding(.horizontal, self.showContents[index] ? 0 : 20)
                            .opacity(
                                self.contentMode == .list ||
                                self.contentMode == .content && self.showContents[index] ? 1 : 0
                            )
                            .onTapGesture {
                                self.showContents[index] = true
                            }
                        }
                        .frame(height: self.showContents[index] ?
                                fullView.size.height + fullView.safeAreaInsets.top +
                                fullView.safeAreaInsets.bottom :
                                min(sampleArticles[index].image.size .height/3, 500))
                        .animation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration : 0.1))
                    }
                }
                .frame(width: fullView.size.width)
            }
        }
    }
}

struct TopBarView : View {
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            VStack(alignment: .leading) {
                Text(getCurrentDate().uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            Spacer()
            AvatarView(image: "profile", width: 40, height: 40)
        }
    }
        
    func getCurrentDate(with format: String = "EEEE, MMM d") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}

struct AvatarView: View {
    let image: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
