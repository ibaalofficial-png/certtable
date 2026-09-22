import SwiftUI
import SwiftData

struct SalesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Sale.date, order: .reverse) private var sales: [Sale]
    @State private var search = ""
    @State private var showingAdd = false

    private var filtered: [Sale] {
        guard !search.isEmpty else { return sales }
        return sales.filter {
            $0.udid.localizedCaseInsensitiveContains(search) ||
            $0.device.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { sale in
                    NavigationLink {
                        SaleDetailView(sale: sale)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(sale.device).font(.headline)
                                Spacer()
                                Text(sale.profit, format: .currency(code: "IDR").precision(.fractionLength(0)))
                                    .foregroundStyle(sale.profit >= 0 ? .green : .red)
                                    .fontWeight(.bold)
                            }
                            Text(sale.udid)
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            HStack {
                                Text(sale.date, format: .dateTime.day().month().year())
                                Spacer()
                                Text(sale.status)
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        modelContext.delete(filtered[index])
                    }
                }
            }
            .searchable(text: $search, prompt: "Cari UDID atau HP")
            .navigationTitle("Penjualan")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddSaleView()
            }
        }
    }
}

struct AddSaleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var date = Date.now
    @State private var udid = ""
    @State private var device = ""
    @State private var cost = ""
    @State private var salePrice = ""
    @State private var status = "Lunas"

    private var costValue: Double { Double(cost.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")) ?? 0 }
    private var saleValue: Double { Double(salePrice.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")) ?? 0 }

    var body: some View {
        NavigationStack {
            Form {
                Section("Data") {
                    DatePicker("Tanggal", selection: $date, displayedComponents: .date)
                    TextField("UDID", text: $udid)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Merek / Model HP", text: $device)
                }
                Section("Keuangan") {
                    TextField("Modal", text: $cost).keyboardType(.decimalPad)
                    TextField("Harga Jual", text: $salePrice).keyboardType(.decimalPad)
                    HStack {
                        Text("Keuntungan")
                        Spacer()
                        Text(saleValue - costValue, format: .currency(code: "IDR").precision(.fractionLength(0)))
                            .foregroundStyle(saleValue - costValue >= 0 ? .green : .red)
                            .fontWeight(.bold)
                    }
                }
                Section("Status") {
                    Picker("Status", selection: $status) {
                        Text("Lunas").tag("Lunas")
                        Text("Belum").tag("Belum")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Tambah Penjualan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        modelContext.insert(Sale(date: date, udid: udid.trimmingCharacters(in: .whitespacesAndNewlines), device: device, cost: costValue, salePrice: saleValue, status: status))
                        dismiss()
                    }
                    .disabled(udid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || device.isEmpty)
                }
            }
        }
    }
}

struct SaleDetailView: View {
    @Bindable var sale: Sale

    var body: some View {
        Form {
            Section("Transaksi") {
                TextField("UDID", text: $sale.udid)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Merek / Model HP", text: $sale.device)
                DatePicker("Tanggal", selection: $sale.date, displayedComponents: .date)
            }
            Section("Keuangan") {
                TextField("Modal", value: $sale.cost, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Harga Jual", value: $sale.salePrice, format: .number)
                    .keyboardType(.decimalPad)
                LabeledContent("Keuntungan") {
                    Text(sale.profit, format: .currency(code: "IDR").precision(.fractionLength(0)))
                        .foregroundStyle(sale.profit >= 0 ? .green : .red)
                        .fontWeight(.bold)
                }
            }
            Section("Status") {
                Picker("Status", selection: $sale.status) {
                    Text("Lunas").tag("Lunas")
                    Text("Belum").tag("Belum")
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Detail")
    }
}
