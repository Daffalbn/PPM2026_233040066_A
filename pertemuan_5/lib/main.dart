import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// 1. MODEL DATA
// ==========================================
class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

// ==========================================
// 2. MAIN APPLICATION WIDGET (NAMED ROUTES)
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            final catatanUntukEdit = settings.arguments as Catatan?;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatanLama: catatanUntukEdit),
            );
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// ==========================================
// 3. HOME PAGE (DENGAN FILTER KATEGORI)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filterTerpilih = 'Semua';
  final _filterOpsi = const ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation pada praktikum pertemuan 3.',
      kategori: 'Kuliah',
      email: 'mahasiswa@univ.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  Future<void> _bukaFormCatatan({Catatan? dataLama}) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/tambah',
      arguments: dataLama,
    );

    if (hasil is Catatan) {
      setState(() {
        if (dataLama == null) {
          _catatan.add(hasil);
          _tampilkanSnackbar('Catatan "${hasil.judul}" berhasil ditambahkan!');
        } else {
          final index = _catatan.indexWhere((element) => element.id == dataLama.id);
          if (index != -1) {
            _catatan[index] = hasil;
            _tampilkanSnackbar('Catatan "${hasil.judul}" berhasil diperbarui!');
          }
        }
      });
    }
  }

  void _hapusCatatan(String id, String judul) {
    setState(() {
      _catatan.removeWhere((element) => element.id == id);
    });
    _tampilkanSnackbar('Catatan "$judul" telah dihapus');
  }

  // Tombol Refresh — reset filter ke "Semua" dan rebuild list
  void _refresh() {
    setState(() => _filterTerpilih = 'Semua');
    _tampilkanSnackbar('Daftar catatan diperbarui');
  }

  void _tampilkanSnackbar(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), duration: const Duration(seconds: 2)),
    );
  }

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final catatanTersaring = _catatan.where((c) {
      if (_filterTerpilih == 'Semua') return true;
      return c.kategori == _filterTerpilih;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Dropdown Filter
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: DropdownButton<String>(
              value: _filterTerpilih,
              underline: const SizedBox(),
              icon: const Icon(Icons.filter_list, color: Colors.indigo),
              style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
              items: _filterOpsi
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _filterTerpilih = v!;
                });
              },
            ),
          ),
          // Tombol Refresh — di sebelah kanan filter
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
        ],
      ),
      body: catatanTersaring.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _catatan.isEmpty
                  ? 'Belum ada catatan.'
                  : 'Tidak ada catatan di kategori $_filterTerpilih',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        // Tarik ke bawah untuk refresh
        onRefresh: () async => _refresh(),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: catatanTersaring.length,
          itemBuilder: (context, i) {
            final c = catatanTersaring[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 1,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    c.kategori == 'Kuliah'
                        ? Icons.school
                        : c.kategori == 'Tugas'
                        ? Icons.task
                        : c.kategori == 'Pribadi'
                        ? Icons.person
                        : Icons.bookmark,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  c.judul,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Kategori: ${c.kategori}',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      _formatTanggal(c.dibuatPada),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent),
                  onPressed: () => _hapusCatatan(c.id, c.judul),
                ),
                onTap: () async {
                  final perintahEdit = await Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: c,
                  );
                  if (perintahEdit == true) {
                    _bukaFormCatatan(dataLama: c);
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaFormCatatan(),
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// 4. REUSE FORM PAGE (TAMBAH & EDIT + REGEX EMAIL)
// ==========================================
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanLama;

  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl;
  late String _kategori;

  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl   = TextEditingController(text: widget.catatanLama?.isi   ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.email ?? '');
    _kategori  = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanHasil = Catatan(
      id        : widget.catatanLama?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      judul     : _judulCtrl.text.trim(),
      isi       : _isiCtrl.text.trim(),
      kategori  : _kategori,
      email     : _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(),
    );

    Navigator.pop(context, catatanHasil);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.catatanLama != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'contoh@domain.com',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                final emailRegex = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                );
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid (ex: nama@email.com)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Isi catatan tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEditMode ? Icons.update : Icons.save),
              label: Text(
                isEditMode ? 'Perbarui Catatan' : 'Simpan Catatan',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: isEditMode ? Colors.orange[800] : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. DETAIL CATATAN PAGE (DENGAN TOMBOL EDIT)
// ==========================================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} pukul '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.indigo),
            tooltip: 'Edit Catatan',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(catatan.kategori),
                  backgroundColor:
                  Theme.of(context).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                      color:
                      Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatTanggal(catatan.dibuatPada),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Pengirim: ${catatan.email}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Divider(height: 40, thickness: 1.2),
            Text(
              catatan.isi,
              style: const TextStyle(
                  fontSize: 16, height: 1.6, letterSpacing: 0.3),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}