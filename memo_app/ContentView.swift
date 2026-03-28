import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var memos: [Memo]

    var body: some View {
        NavigationStack {
            List {
                ForEach(memos) { memo in
                    NavigationLink {
                        MemoDetailView(memo: memo)
                    } label: {
                        Text(memo.content.isEmpty ? "新規メモ" : memo.content).lineLimit(1)
                        Text(memo.createdAt, format: .dateTime.year().month().day().hour().minute())
                    }
                }
                .onDelete(perform: deleteMemo)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addMemo) {
                        Label("Add Memo", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addMemo() {
        withAnimation {
            let newMemo = Memo(createdAt: Date())
            modelContext.insert(newMemo)
        }
    }

    private func deleteMemo(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(memos[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Memo.self, inMemory: true)
}
