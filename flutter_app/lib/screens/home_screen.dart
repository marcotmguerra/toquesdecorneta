import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import 'lista_screen.dart';
import 'simulado/simulado_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  void _tentarTrocarAba(int index) {
    final provider = context.read<AppProvider>();
    if (provider.provaAtiva) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sair do simulado?'),
          content: const Text('Você está no meio do simulado. Deseja sair e perder o progresso?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                provider.resetarProva();
                setState(() => _tab = index);
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      );
    } else {
      setState(() => _tab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.ac;
    final provider = context.watch<AppProvider>();

    final tabs = [
      const ListaScreen(),
      const SimuladoScreen(),
      const InfoScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Toques de Corneta',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(provider.darkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            onPressed: () => provider.setDarkMode(!provider.darkMode),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: ac.border),
        ),
      ),
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _tentarTrocarAba,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.music_note_outlined), label: 'Toques'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined),  label: 'Simulado'),
          NavigationDestination(icon: Icon(Icons.info_outline),         label: 'Informações'),
        ],
      ),
    );
  }
}
