//
//  ContentView.swift
//  FileBookmark
//
//  Created by wdz on 2025/6/29.
//

import SwiftUI

struct ContentView: View {
    @State var _selected = 0
    
    var body: some View {
        VStack {
            Button {
                let pb = NSPasteboard.general
                let item = pb.pasteboardItems?[0]
                let fileURLData = item!.data(forType: .fileURL)
                let filePath = String(data: fileURLData!, encoding: .utf8)
                let fileURL = URL(fileURLWithPath: filePath!)
                let bookmarkData = try! fileURL.bookmarkData(options: .withSecurityScope,
                                                             includingResourceValuesForKeys: nil,
                                                             relativeTo: nil)
                UserDefaults.standard.set(bookmarkData, forKey: "bookmark")
            } label: {
                Text("读取剪切板")
            }
            
            Button {
                let bookmarkData = UserDefaults.standard.data(forKey: "bookmark")
                var isStale = false
                let url = try? URL.init(resolvingBookmarkData: bookmarkData!,
                                         options: .withSecurityScope,
                                         relativeTo: nil,
                                         bookmarkDataIsStale: &isStale);
                if (url != nil) {
                    _ = url!.startAccessingSecurityScopedResource()
                    let content = try? String(contentsOf: url!, encoding: .utf8)
                    print("----> content is: \(content ?? "Empty")")
                    url!.stopAccessingSecurityScopedResource()
                }
                
            } label: {
                Text("读取文件内容")
            }
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: -20) {
                        ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].indices, id: \.self) { index in
                            if (index % 2 == 1) {
                                Text("")
                                    .frame(width: 60, height: 100)
                            } else {
                                Text("\(index)")
                                    .frame(width: 100, height: 100)
                                    .background(_selected == index ? .red : .green)
                                    .onTapGesture { _ in
                                        _selected = index
                                    }
                            }
                        }
                    }
                }
                .onChange(of: _selected) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue + 1 >= 11 ? newValue : newValue + 1);
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
