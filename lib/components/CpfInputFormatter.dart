import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove todos os caracteres não numéricos do novo valor
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita o tamanho para 11 dígitos (o máximo para um CPF sem formatação)
    String cpf = newText.length > 11 ? newText.substring(0, 11) : newText;

    String formattedText = '';
    int newTextLength = cpf.length;

    // Aplica a formatação XXX.XXX.XXX-XX
    if (newTextLength > 0) {
      formattedText += cpf.substring(0, newTextLength > 3 ? 3 : newTextLength);
    }
    if (newTextLength > 3) {
      formattedText += '.';
      formattedText += cpf.substring(3, newTextLength > 6 ? 6 : newTextLength);
    }
    if (newTextLength > 6) {
      formattedText += '.';
      formattedText += cpf.substring(6, newTextLength > 9 ? 9 : newTextLength);
    }
    if (newTextLength > 9) {
      formattedText += '-';
      formattedText += cpf.substring(9, newTextLength);
    }

    // Calcula a nova posição do cursor
    // Este é um cálculo simples, pode precisar de ajustes para casos mais complexos
    // de inserção/deleção no meio do texto.
    int selectionIndex = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
