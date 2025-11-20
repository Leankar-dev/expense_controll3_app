Objetivo
Gerar e compartilhar relatórios financeiros em múltiplos formatos.
Formatos Suportados

✅ Excel (syncfusion_flutter_xlsio)
✅ CSV
✅ PDF

Funcionalidades

Relatório mensal detalhado
Análise por categoria
Resumo anual
Extrato customizado por período

Compartilhamento

WhatsApp
Email
Compartilhamento nativo (share_plus)

ExportViewModel
dartclass ExportViewModel extends StateNotifier<ExportState> {
  final ExportToExcelUseCase _exportToExcelUseCase;
  final ShareReportUseCase _shareReportUseCase;

  Future<void> exportToExcel(List<Transaction> transactions) async {
    // Gera arquivo Excel e compartilha
  }
}