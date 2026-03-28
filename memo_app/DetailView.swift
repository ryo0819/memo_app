import SwiftUI
import SwiftData

struct MemoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var memo: Memo

    @State private var showingDeleteAlert = false
    @State private var showToast = false

    var body: some View {
        ZStack{
            VStack {
                TextEditor(text: $memo.content)
                    .padding()
                    .navigationTitle("メモを編集")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: copyToClipboard) {
                        Label("コピー", systemImage: "doc.on.doc")
                    }

                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                }
            }
            .alert("メモの削除", isPresented: $showingDeleteAlert) {
                Button("削除", role: .destructive) {
                    deleteMemo()
                }
                Button("キャンセル", role: .cancel) { }
            } message: {
                Text("このメモを削除してもよろしいですか？この操作は取り消せません。")
            }

            if showToast {
                VStack {
                    Spacer()
                    Text("クリップボードにコピーしました")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Capsule().fill(Color.black.opacity(0.7)))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .padding(.bottom, 50)
                .zIndex(1)
            }
        }
    }


    private func copyToClipboard() {
        UIPasteboard.general.string = memo.content
        withAnimation {
            showToast = true
        }

        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation {
                showToast = false
            }
        }
    }

    private func deleteMemo() {
        modelContext.delete(memo)
        dismiss()
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Memo.self, configurations: config)

    let sampleMemo = Memo(content: "これはテスト用のメモです")

    return NavigationStack {
        MemoDetailView(memo: sampleMemo)
            .modelContainer(container)
    }
}
