// lib/components/guest_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/hsoepde_model.dart';
import 'package:intl/intl.dart';

class GuestCard extends StatelessWidget {
  final Hospede hospede;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(HospedeStatus) onStatusChange;

  const GuestCard({
    super.key,
    required this.hospede,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  // Helper para o visual do Chip de Status
  Widget _buildStatusChip(HospedeStatus status) {
    Color chipColor;
    Color textColor;
    String label;

    switch (status) {
      case HospedeStatus.andamento:
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade900;
        label = 'EM ANDAMENTO';
        break;
      case HospedeStatus.concluido:
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        label = 'CONCLUÍDO';
        break;
      case HospedeStatus.cancelado:
        chipColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        label = 'CANCELADO';
        break;
    }
    return Chip(
      label: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 10, color: textColor),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      visualDensity: VisualDensity.compact,
    );
  }

  // Helper para criar as linhas de informação e evitar repetição de código
  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Text(
            '$title: ',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Formatador para as datas
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEÇÃO HEADER: NOME E STATUS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    hospede.nome,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(hospede.status),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // --- SEÇÃO DE INFORMAÇÕES DETALHADAS ---
            _buildInfoRow(context, Icons.perm_identity, 'CPF', hospede.cpf),
            _buildInfoRow(context, Icons.bed_outlined, 'Quarto',
                '${hospede.tipoQuarto} - Nº: ${hospede.numeroQuarto}'),
            _buildInfoRow(context, Icons.date_range_outlined, 'Período',
                '${dateFormat.format(hospede.dataEntrada)} a ${dateFormat.format(hospede.dataSaida)}'),

            const SizedBox(height: 12),
            const Divider(),

            // --- SEÇÃO DE AÇÕES (BOTÕES) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                  onPressed: onEdit,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: Colors.red),
                  label: const Text('Excluir',
                      style: TextStyle(color: Colors.red)),
                  onPressed: onDelete,
                ),
                PopupMenuButton<HospedeStatus>(
                  onSelected: onStatusChange,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<HospedeStatus>>[
                    const PopupMenuItem<HospedeStatus>(
                        value: HospedeStatus.andamento,
                        child: Text('Em Andamento')),
                    const PopupMenuItem<HospedeStatus>(
                        value: HospedeStatus.concluido,
                        child: Text('Concluído')),
                    const PopupMenuItem<HospedeStatus>(
                        value: HospedeStatus.cancelado,
                        child: Text('Cancelado')),
                  ],
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sync_alt, size: 18),
                        SizedBox(width: 8),
                        Text('Status')
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
