import 'package:flutter/material.dart';

class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Visão Geral'),
            Tab(text: 'Cadastros'),
            Tab(text: 'Aulas'),
            Tab(text: 'Manutenção'),
            Tab(text: 'Recados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _visaoGeral(),
          _cadastros(),
          _aulasEAuloes(),
          _manutencao(),
          _recados(),
        ],
      ),
    );
  }

  Widget _visaoGeral() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _infoCard(Icons.message, '3', 'Recados'),
          _infoCard(Icons.person, '82', 'Alunos Ativos'),
          _infoCard(Icons.schedule, '12', 'Aulas Agendadas'),
          _infoCard(Icons.music_note, '4', 'Mix de Músicas'),
          _infoCard(Icons.directions_bike, '18', 'Bikes OK'),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String value, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cadastros() {
    final cadastros = [
      {'title': 'Vídeo Aula', 'route': '/form_video_aula'},
      {'title': 'Aluno', 'route': ''},
      {'title': 'Fabricante', 'route': ''},
      {'title': 'Sala', 'route': ''},
      {'title': 'Tipo Manutenção', 'route': '/form_tipo_manutencao'},
      {'title': 'Categoria Música', 'route': ''},
      {'title': 'Banda Artista', 'route': ''},
      {'title': 'Turma', 'route': ''},
      {'title': 'Bike', 'route': ''},
      {'title': 'Música', 'route': ''},
      {'title': 'Mix Aula (Playlist)', 'route': ''},
      {'title': 'Grupo Aluno', 'route': ''},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cadastros.length,
      itemBuilder: (context, index) {
        return _cadastroTile(
            context, cadastros[index]['title']!, cadastros[index]['route']!);
      },
    );
  }

  Widget _cadastroTile(BuildContext context, String title, String route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  Widget _aulasEAuloes() {
    return const Center(child: Text('Seção de Aulas'));
  }

  Widget _manutencao() {
    return const Center(child: Text('Seção de Manutenção'));
  }

  Widget _recados() {
    return const Center(child: Text('Seção de Recados'));
  }
}
