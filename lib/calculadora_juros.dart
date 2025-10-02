import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importação para fazer a  formatação de input


class CalculadoraJurosApp extends StatelessWidget {
  const CalculadoraJurosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de Juros',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100], // Fundo suave
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          floatingLabelStyle: const TextStyle(color: Colors.teal),
        ),
      ),
      home: const CalculadoraJurosPage(),
    );
  }
}


class CalculadoraJurosPage extends StatefulWidget {
  const CalculadoraJurosPage({Key? key}) : super(key: key);

  @override
  State createState() => _CalculadoraJurosPageState();
}

class _CalculadoraJurosPageState extends State<CalculadoraJurosPage> {
  final capitalController = TextEditingController();
  final aplicacaoMensalController = TextEditingController();
  final mesesController = TextEditingController();
  final taxaJurosMesController = TextEditingController();

  double montante = 0.0;
  List<double> rendimentosMensais = [];

  void _calcularJurosCompostos() {
    final double capitalInicial = double.tryParse(capitalController.text) ?? 0.0;
    final double aplicacaoMensal = double.tryParse(aplicacaoMensalController.text) ?? 0.0;
    final int meses = int.tryParse(mesesController.text) ?? 0;
    final double taxaJurosMes = (double.tryParse(taxaJurosMesController.text) ?? 0.0) / 100;


    FocusScope.of(context).unfocus();

    setState(() {
      rendimentosMensais.clear();
      double capitalAcumulado = capitalInicial;

      for (int i = 0; i < meses; i++) {
        final double rendimentoDoMes = capitalAcumulado * taxaJurosMes;
        capitalAcumulado += rendimentoDoMes + aplicacaoMensal;
        rendimentosMensais.add(rendimentoDoMes);
      }

      if (meses > 0) {
        montante = capitalAcumulado - aplicacaoMensal;
      } else {
        montante = capitalAcumulado;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de Juros Compostos"),
      ),
      // SingleChildScrollView para evitar que o conteudo quebre
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card que agrupa os campos de entrada
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Parâmetros do Investimento',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _campoTexto(
                      controller: capitalController,
                      label: 'Investimento Inicial (R\$)',
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(height: 16),
                    _campoTexto(
                      controller: aplicacaoMensalController,
                      label: 'Aporte Mensal (R\$)',
                      icon: Icons.add_chart_sharp,
                    ),
                    const SizedBox(height: 16),
                    _campoTexto(
                      controller: mesesController,
                      label: 'Período (meses)',
                      icon: Icons.calendar_today,
                      isInteger: true,
                    ),
                    const SizedBox(height: 16),
                    _campoTexto(
                      controller: taxaJurosMesController,
                      label: 'Rentabilidade Mensal (%)',
                      icon: Icons.percent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão de calculo com estilo definido
            ElevatedButton(
              onPressed: _calcularJurosCompostos,
              child: const Text('CALCULAR'),
            ),
            const SizedBox(height: 24),

            // Card para exibição dos resultados
            if (montante > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Resultado Final',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "R\$ ${montante.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Divider(height: 30),
                      const Text(
                        'Rendimentos Mês a Mês',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Utilizei um ListView.separated para adicionar divisores
                      ListView.separated(
                        shrinkWrap: true, // essa parte é necessario dentro de uma Column
                        physics: const NeverScrollableScrollPhysics(), // Desativa o scroll da lista interna
                        itemCount: rendimentosMensais.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.withOpacity(0.1),
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal),
                              ),
                            ),
                            title: Text(
                                "Rendimento: R\$ ${rendimentosMensais[index].toStringAsFixed(2)}"),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isInteger = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
      ),

      keyboardType: isInteger
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: isInteger
          ? [FilteringTextInputFormatter.digitsOnly]
          : [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
    );
  }
}