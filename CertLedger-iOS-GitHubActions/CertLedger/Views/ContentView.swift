import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "chart.bar.xaxis") }
            SalesView()
                .tabItem { Label("Penjualan", systemImage: "list.bullet.rectangle") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(.cyan)
    }
}

struct DashboardView: View {
    @Query private var sales: [Sale]

    private var omzet: Double { sales.reduce(0) { $0 + $1.salePrice } }
    private var modal: Double { sales.reduce(0) { $0 + $1.cost } }
    private var profit: Double { sales.reduce(0) { $0 + $1.profit } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("CertLedger")
                            .font(.largeTitle.bold())
                        Text("Rekap penjualan dalam satu tempat.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    MetricCard(title: "Keuntungan", value: profit, icon: "arrow.up.right", prominent: true)
                    HStack(spacing: 12) {
                        MetricCard(title: "Omzet", value: omzet, icon: "banknote")
                        MetricCard(title: "Modal", value: modal, icon: "wallet.pass")
                    }
                    HStack(spacing: 12) {
                        CountCard(title: "Penjualan", value: sales.count, icon: "shippingbox")
                        CountCard(title: "Lunas", value: sales.filter { $0.status == "Lunas" }.count, icon: "checkmark.circle")
                    }

                    if sales.isEmpty {
                        ContentUnavailableView("Belum ada penjualan", systemImage: "tray", description: Text("Tambahkan transaksi pertama dari menu Penjualan."))
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: Double
    let icon: String
    var prominent = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value, format: .currency(code: "IDR").precision(.fractionLength(0)))
                .font(prominent ? .system(size: 30, weight: .bold) : .title2.bold())
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.08)))
    }
}

struct CountCard: View {
    let title: String
    let value: Int
    let icon: String

    var body: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: icon)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.title.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Tentang") {
                    LabeledContent("App", value: "CertLedger")
                    LabeledContent("Version", value: "1.0")
                    Text("Data transaksi disimpan secara lokal menggunakan SwiftData.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
