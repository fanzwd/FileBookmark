//
//  ContentView.swift
//  FileBookmark
//
//  Created by wdz on 2025/6/29.
//

import SwiftUI

struct ContentView: View {
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

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
