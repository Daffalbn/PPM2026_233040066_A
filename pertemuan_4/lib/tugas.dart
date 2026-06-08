import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Palet warna & style terpusat
// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFFF4F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF3D5AFE);
  static const primaryLight = Color(0xFFE8ECFF);
  static const accent = Color(0xFF00BFA5);
  static const danger = Color(0xFFE53935);
  static const textMain = Color(0xFF1A1D2E);
  static const textSub = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E9F2);

  // Warna chip per kategori
  static Color chipBg(String k) {
    switch (k) {
      case 'Kuliah':
        return const Color(0xFFEDE7F6);
      case 'Tugas':
        return const Color(0xFFFFF3E0);
      case 'Pribadi':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFE3F2FD);
    }
  }

  static Color chipFg(String k) {
    switch (k) {
      case 'Kuliah':
        return const Color(0xFF6A1B9A);
      case 'Tugas':
        return const Color(0xFFE65100);
      case 'Pribadi':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF1565C0);
    }
  }

  static IconData chipIcon(String k) {
    switch (k) {
      case 'Kuliah':
        return Icons.school_rounded;
      case 'Tugas':
        return Icons.assignment_rounded;
      case 'Pribadi':
        return Icons.person_rounded;
      default:
        return Icons.label_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App root
// ─────────────────────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textMain,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.textMain,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          labelStyle: const TextStyle(color: AppColors.textSub),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.danger, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const HomePage(),
      routes: {'/tambah': (context) => const TambahCatatanPage()},
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final data = settings.arguments;
          if (data == null || data is! Map<String, dynamic>) return null;
          return MaterialPageRoute(
            builder: (_) => TambahCatatanPage(
              catatan: data['catatan'],
              index: data['index'],
            ),
          );
        }
        return null;
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      emailPengirim: 'mahasiswa@gmail.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  String _filterKategori = 'Semua';
  final List<String> _opsiFilter = [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  List<Catatan> get _catatanFiltered {
    if (_filterKategori == 'Semua') return _catatan;
    return _catatan.where((c) => c.kategori == _filterKategori).toList();
  }

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
      if (!mounted) return;
      _showSnack(
        'Catatan "${hasil.judul}" ditambahkan',
        Icons.check_circle_rounded,
      );
    }
  }

  Future<void> _editCatatan(int index) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/edit',
      arguments: {'catatan': _catatan[index], 'index': index},
    );
    if (hasil is Map<String, dynamic>) {
      setState(() => _catatan[hasil['index']] = hasil['catatan']);
      if (!mounted) return;
      _showSnack(
        'Catatan "${hasil['catatan'].judul}" diperbarui',
        Icons.edit_rounded,
      );
    }
  }

  void _hapusCatatan(int indexAsli) {
    final catatanDihapus = _catatan[indexAsli];
    setState(() => _catatan.removeAt(indexAsli));
    _showSnack(
      'Catatan "${catatanDihapus.judul}" dihapus',
      Icons.delete_rounded,
    );
  }

  void _showSnack(String msg, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: AppColors.textMain,
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataTampil = _catatanFiltered;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Catatan Mahasiswa'),
            Text(
              '${_catatan.length} catatan tersimpan',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSub,
              ),
            ),
          ],
        ),
        actions: [
          // Filter dropdown di AppBar
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String>(
                value: _filterKategori,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.filter_list_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                dropdownColor: AppColors.surface,
                items: _opsiFilter.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _filterKategori = value);
                },
              ),
            ),
          ),
        ],
      ),

      body: dataTampil.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: dataTampil.length,
              itemBuilder: (context, i) {
                final c = dataTampil[i];
                final indexAsli = _catatan.indexOf(c);
                return _CatatanCard(
                  catatan: c,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailCatatanPage(
                          catatan: c,
                          index: indexAsli,
                          onEdit: _editCatatan,
                        ),
                      ),
                    );
                  },
                  onDelete: () => _hapusCatatan(indexAsli),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaTambahCatatan,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada catatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap tombol + untuk menambahkan catatan baru',
            style: TextStyle(fontSize: 13, color: AppColors.textSub),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card catatan
// ─────────────────────────────────────────────────────────────────────────────
class _CatatanCard extends StatelessWidget {
  final Catatan catatan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CatatanCard({
    required this.catatan,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.chipBg(catatan.kategori);
    final fg = AppColors.chipFg(catatan.kategori);
    final icon = AppColors.chipIcon(catatan.kategori);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ikon kategori
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: fg, size: 22),
                ),
                const SizedBox(width: 14),

                // Konten
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catatan.judul,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMain,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        catatan.isi,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSub,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 13,
                            color: AppColors.textSub,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              catatan.emailPengirim,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSub,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tombol hapus
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger,
                    size: 20,
                  ),
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TambahCatatanPage
// ─────────────────────────────────────────────────────────────────────────────
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatan;
  final int? index;

  const TambahCatatanPage({super.key, this.catatan, this.index});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    if (widget.catatan != null) {
      _judulCtrl.text = widget.catatan!.judul;
      _isiCtrl.text = widget.catatan!.isi;
      _kategori = widget.catatan!.kategori;
      _emailCtrl.text = widget.catatan!.emailPengirim;
    }
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

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      dibuatPada: DateTime.now(),
    );

    if (widget.catatan != null) {
      Navigator.pop(context, {'catatan': catatanBaru, 'index': widget.index});
    } else {
      Navigator.pop(context, catatanBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isEdit
                        ? 'Perbarui informasi catatan'
                        : 'Isi semua kolom di bawah ini',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionLabel('Judul', Icons.title_rounded),
            const SizedBox(height: 8),
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                hintText: 'Masukkan judul catatan',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),

            const SizedBox(height: 20),

            _sectionLabel('Email Pengirim', Icons.email_rounded),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'contoh@email.com'),
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return 'Email wajib diisi';
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim()))
                  return 'Format email tidak valid';
                return null;
              },
            ),

            const SizedBox(height: 20),

            _sectionLabel('Kategori', Icons.category_rounded),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(hintText: 'Pilih kategori'),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
              ),
              items: _kategoriOpsi.map((k) {
                return DropdownMenuItem(
                  value: k,
                  child: Row(
                    children: [
                      Icon(
                        AppColors.chipIcon(k),
                        size: 18,
                        color: AppColors.chipFg(k),
                      ),
                      const SizedBox(width: 8),
                      Text(k),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _kategori = v);
              },
            ),

            const SizedBox(height: 20),

            _sectionLabel('Isi Catatan', Icons.notes_rounded),
            const SizedBox(height: 8),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Tulis isi catatan di sini...',
                alignLabelWithHint: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Isi wajib diisi';
                return null;
              },
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEdit ? Icons.save_rounded : Icons.check_rounded),
              label: Text(
                isEdit ? 'Simpan Perubahan' : 'Simpan Catatan',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSub),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSub,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailCatatanPage
// ─────────────────────────────────────────────────────────────────────────────
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  final int index;
  final Function(int) onEdit;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.chipBg(catatan.kategori);
    final fg = AppColors.chipFg(catatan.kategori);
    final icon = AppColors.chipIcon(catatan.kategori);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                onEdit(index);
              },
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text(
                'Edit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 14, color: fg),
                        const SizedBox(width: 6),
                        Text(
                          catatan.kategori,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    catatan.judul,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Garis pemisah tipis
                  const Divider(color: AppColors.divider),

                  const SizedBox(height: 10),

                  // Email
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.email_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Pengirim',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSub,
                              ),
                            ),
                            Text(
                              catatan.emailPengirim,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Isi catatan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        size: 16,
                        color: AppColors.textSub,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'ISI CATATAN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSub,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    catatan.isi,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textMain,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
