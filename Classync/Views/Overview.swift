import SwiftUI

struct Overview: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            Text("AI Implementation Coming Soon")
                .font(.title)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    Overview()
}
