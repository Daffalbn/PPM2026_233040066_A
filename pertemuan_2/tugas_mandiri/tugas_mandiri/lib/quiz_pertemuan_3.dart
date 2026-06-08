import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8FAA72),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

// =====================================================================
// MODEL PENGALAMAN  ← BARU
// =====================================================================
class ExperienceItem {
  String title;
  String description;
  String? imagePath; // null = tampilkan placeholder icon

  ExperienceItem({
    required this.title,
    required this.description,
    this.imagePath,
  });

  ExperienceItem copyWith({
    String? title,
    String? description,
    String? imagePath,
  }) {
    return ExperienceItem(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

// =====================================================================
// MODEL DATA PROFIL
// =====================================================================
class ProfileData {
  String name;
  String title;
  String about;
  String education;
  String gpa;
  String hobbies;
  String email;
  String phone;
  List<String> skills;
  String? imagePath;

  ProfileData({
    this.name = 'Chalida Rahma Listy H',
    this.title = 'Mahasiswa Teknik Informatika',
    this.about =
        'Saya suka belajar hal baru, terutama teknologi dan mobile app.',
    this.education = 'Universitas Pasundan',
    this.gpa = '3.99',
    this.hobbies = 'Coding • Membaca • Olahraga',
    this.email = 'chalida.rahma@email.com',
    this.phone = '+62 888-888-888',
    this.skills = const ['Python', 'Flutter', 'React', 'HTML', 'CSS'],
    this.imagePath,
  });

  ProfileData copyWith({
    String? name,
    String? title,
    String? about,
    String? education,
    String? gpa,
    String? hobbies,
    String? email,
    String? phone,
    List<String>? skills,
    String? imagePath,
  }) {
    return ProfileData(
      name: name ?? this.name,
      title: title ?? this.title,
      about: about ?? this.about,
      education: education ?? this.education,
      gpa: gpa ?? this.gpa,
      hobbies: hobbies ?? this.hobbies,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      skills: skills ?? this.skills,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

// =====================================================================
// PROFILE PAGE
// =====================================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData _profile = ProfileData();

  // ── daftar pengalaman ────────────────────────────────────────
  List<ExperienceItem> _experiences = [
    ExperienceItem(
      title: 'Head of Human Resource',
      description:
          'Bertanggung jawab untuk mengelola sumber daya manusia di organisasi.',
    ),
    ExperienceItem(
      title: 'Asisten Lab Pemograman Basis Data',
      description:
          'Membimbing mahasiswa semester 3 dalam mata kuliah Pemograman Basis Data di Universitas Pasundan.',
    ),
  ];

  // Warna tema
  static const Color _primaryGreen = Color(0xFF8FAA72);
  static const Color _lightGreen1 = Color(0xFFC1D4B6);
  static const Color _lightGreen2 = Color(0xFFEFF5D9);
  static const Color _appBarColor = Color.fromARGB(255, 218, 232, 205);

  void _goToEditPage() async {
    final updated = await Navigator.push<ProfileData>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilePage(profile: _profile)),
    );
    if (updated != null) {
      setState(() => _profile = updated);
    }
  }

  // ─--Navigasi ke halaman edit pengalaman ──────────────────────
  void _goToEditExperiencePage() async {
    final updated = await Navigator.push<List<ExperienceItem>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditExperiencePage(experiences: _experiences),
      ),
    );
    if (updated != null) {
      setState(() => _experiences = updated);
    }
  }

  Widget _buildAvatar({double radius = 50}) {
    if (_profile.imagePath != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(_profile.imagePath!)),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: const AssetImage('assets/images/profile.jpeg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: _appBarColor,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 223, 233, 219),
                    Color.fromARGB(255, 218, 232, 205),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Color.fromARGB(255, 20, 20, 20),
                  fontSize: 24,
                ),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Fitur pengaturan belum tersedia'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
            // ── menu edit pengalaman di drawer ─────────────────
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Edit Pengalaman'),
              onTap: () {
                Navigator.pop(context);
                _goToEditExperiencePage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_lightGreen1, _lightGreen2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER
              Center(
                child: Column(
                  children: [
                    _buildAvatar(radius: 50),
                    const SizedBox(height: 12),
                    Text(
                      _profile.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profile.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 98, 96, 96),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // STATISTIK
              const Row(
                children: [
                  Expanded(
                    child: _StatBox(label: 'Post', value: '12'),
                  ),
                  Expanded(
                    child: _StatBox(label: 'Teman', value: '128K'),
                  ),
                  Expanded(
                    child: _StatBox(label: 'Like', value: '1.2M'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // SECTION CARDS
              _SectionCard(
                icon: Icons.info_outline,
                title: 'Tentang Saya',
                content: Text(_profile.about),
              ),
              _SectionCard(
                icon: Icons.school,
                title: 'Pendidikan',
                content: Text(
                  '${_profile.education} — Semester 6\nIPK: ${_profile.gpa}',
                ),
              ),
              _SectionCard(
                icon: Icons.favorite,
                title: 'Hobi & Minat',
                content: Text(_profile.hobbies),
              ),
              _SectionCard(
                icon: Icons.email,
                title: 'Kontak',
                content: Text('${_profile.email}\n${_profile.phone}'),
              ),
              _SectionCard(
                icon: Icons.stars,
                title: 'Skills',
                content: Wrap(
                  spacing: 8,
                  children: _profile.skills
                      .map((s) => Chip(label: Text(s)))
                      .toList(),
                ),
              ),

              // ──SECTION CARD PENGALAMAN ────────────────────────
              _ExperienceSectionCard(experiences: _experiences),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryGreen,
        onPressed: _goToEditPage,
        child: const Icon(Icons.edit),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

// =====================================================================
// SECTION CARD PENGALAMAN (tampil di halaman utama)
// =====================================================================
class _ExperienceSectionCard extends StatelessWidget {
  final List<ExperienceItem> experiences;

  const _ExperienceSectionCard({required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF).withOpacity(0.9),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: const [
                Icon(Icons.work_outline, color: Colors.blue, size: 28),
                SizedBox(width: 16),
                Text(
                  'Pengalaman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Jika belum ada pengalaman
            if (experiences.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Belum ada pengalaman. Tambahkan melalui menu drawer.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            // Daftar pengalaman
            ...experiences.map((exp) => _ExperienceListItem(exp: exp)),
          ],
        ),
      ),
    );
  }
}

/// Satu item pengalaman di dalam section card
class _ExperienceListItem extends StatelessWidget {
  final ExperienceItem exp;
  const _ExperienceListItem({required this.exp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar pengalaman
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: exp.imagePath != null
                ? Image.file(
                    File(exp.imagePath!),
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF0D2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.work_outline,
                      size: 36,
                      color: Color(0xFF8FAA72),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Judul & deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exp.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 80, 80, 80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HALAMAN EDIT PENGALAMAN
// =====================================================================
class EditExperiencePage extends StatefulWidget {
  final List<ExperienceItem> experiences;
  const EditExperiencePage({super.key, required this.experiences});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  static const Color _primaryGreen = Color(0xFF8FAA72);
  static const Color _appBarColor = Color.fromARGB(255, 218, 232, 205);
  static const Color _bgTop = Color(0xFFC1D4B6);
  static const Color _bgBottom = Color(0xFFEFF5D9);

  late List<ExperienceItem> _experiences;

  @override
  void initState() {
    super.initState();
    // Deep copy agar perubahan tidak langsung mempengaruhi state parent
    _experiences = widget.experiences
        .map(
          (e) => ExperienceItem(
            title: e.title,
            description: e.description,
            imagePath: e.imagePath,
          ),
        )
        .toList();
  }

  // ── Tambah pengalaman baru ──────────────────────────────────────────
  void _addExperience() {
    setState(() {
      _experiences.add(ExperienceItem(title: '', description: ''));
    });
  }

  // ── Hapus pengalaman ───────────────────────────────────────────────
  void _removeExperience(int index) {
    setState(() => _experiences.removeAt(index));
  }

  // ── Simpan & kembali ───────────────────────────────────────────────
  void _save() {
    // Validasi: semua judul tidak boleh kosong
    for (int i = 0; i < _experiences.length; i++) {
      if (_experiences[i].title.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Judul pengalaman ke-${i + 1} tidak boleh kosong!'),
          ),
        );
        return;
      }
    }
    Navigator.pop(context, List<ExperienceItem>.from(_experiences));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengalaman'),
        backgroundColor: _appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Batal',
        ),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_alt_rounded, color: Color(0xFF3D5A26)),
            label: const Text(
              'Simpan',
              style: TextStyle(
                color: Color(0xFF3D5A26),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _experiences.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada pengalaman.\nTekan + untuk menambahkan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: _experiences.length,
                      itemBuilder: (context, index) {
                        return _ExperienceEditCard(
                          key: ValueKey(index),
                          item: _experiences[index],
                          index: index,
                          onChanged: (updated) {
                            setState(() => _experiences[index] = updated);
                          },
                          onDelete: () => _removeExperience(index),
                        );
                      },
                    ),
            ),

            // Tombol tambah & simpan di bawah
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              color: Colors.transparent,
              child: Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: _addExperience,
                    icon: const Icon(Icons.add, color: _primaryGreen),
                    label: const Text(
                      'Tambah Pengalaman',
                      style: TextStyle(color: _primaryGreen),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primaryGreen),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
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

// =====================================================================
// KARTU EDIT SATU ITEM PENGALAMAN
// =====================================================================
class _ExperienceEditCard extends StatefulWidget {
  final ExperienceItem item;
  final int index;
  final ValueChanged<ExperienceItem> onChanged;
  final VoidCallback onDelete;

  const _ExperienceEditCard({
    super.key,
    required this.item,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ExperienceEditCard> createState() => _ExperienceEditCardState();
}

class _ExperienceEditCardState extends State<_ExperienceEditCard> {
  static const Color _primaryGreen = Color(0xFF8FAA72);

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.item.title);
    _descCtrl = TextEditingController(text: widget.item.description);
    _imagePath = widget.item.imagePath;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _notifyParent() {
    widget.onChanged(
      ExperienceItem(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        imagePath: _imagePath,
      ),
    );
  }

  // ── Pilih gambar pengalaman ────────────────────────────────────────
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Pilih Gambar Pengalaman',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFC1D4B6),
                  child: Icon(Icons.camera_alt, color: Color(0xFF8FAA72)),
                ),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() => _imagePath = picked.path);
                    _notifyParent();
                  }
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFC1D4B6),
                  child: Icon(Icons.photo_library, color: Color(0xFF8FAA72)),
                ),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() => _imagePath = picked.path);
                    _notifyParent();
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header kartu ─────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.work_outline, color: Colors.blue, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Pengalaman ${widget.index + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Hapus pengalaman ini',
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Gambar pengalaman ─────────────────────────────────────
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _imagePath != null
                    ? Image.file(
                        File(_imagePath!),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF5D9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFB8D4A0),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 44,
                              color: Color(0xFF8FAA72),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap untuk pilih gambar',
                              style: TextStyle(
                                color: Color(0xFF8FAA72),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            // Tombol ganti gambar jika sudah ada
            if (_imagePath != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.photo_camera,
                    color: _primaryGreen,
                    size: 18,
                  ),
                  label: const Text(
                    'Ganti Gambar',
                    style: TextStyle(color: _primaryGreen, fontSize: 13),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // ── Judul pengalaman ──────────────────────────────────────
            TextField(
              controller: _titleCtrl,
              onChanged: (_) => _notifyParent(),
              decoration: InputDecoration(
                labelText: 'Judul Pengalaman',
                hintText: 'Contoh: Magang di Perusahaan X',
                filled: true,
                fillColor: const Color(0xFFF5FAF0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _primaryGreen, width: 2),
                ),
                labelStyle: const TextStyle(color: Color(0xFF6A8A52)),
              ),
            ),
            const SizedBox(height: 12),

            // ── Deskripsi pengalaman ──────────────────────────────────
            TextField(
              controller: _descCtrl,
              onChanged: (_) => _notifyParent(),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Singkat',
                hintText: 'Ceritakan pengalaman Anda...',
                filled: true,
                fillColor: const Color(0xFFF5FAF0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _primaryGreen, width: 2),
                ),
                labelStyle: const TextStyle(color: Color(0xFF6A8A52)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EDIT PROFILE PAGE
// =====================================================================
class EditProfilePage extends StatefulWidget {
  final ProfileData profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color _primaryGreen = Color(0xFF8FAA72);
  static const Color _appBarColor = Color.fromARGB(255, 218, 232, 205);
  static const Color _bgTop = Color(0xFFC1D4B6);
  static const Color _bgBottom = Color(0xFFEFF5D9);

  late TextEditingController _nameCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _aboutCtrl;
  late TextEditingController _educationCtrl;
  late TextEditingController _gpaCtrl;
  late TextEditingController _hobbiesCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  late List<String> _skills;
  final TextEditingController _newSkillCtrl = TextEditingController();

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameCtrl = TextEditingController(text: p.name);
    _titleCtrl = TextEditingController(text: p.title);
    _aboutCtrl = TextEditingController(text: p.about);
    _educationCtrl = TextEditingController(text: p.education);
    _gpaCtrl = TextEditingController(text: p.gpa);
    _hobbiesCtrl = TextEditingController(text: p.hobbies);
    _emailCtrl = TextEditingController(text: p.email);
    _phoneCtrl = TextEditingController(text: p.phone);
    _skills = List<String>.from(p.skills);
    _imagePath = p.imagePath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _aboutCtrl.dispose();
    _educationCtrl.dispose();
    _gpaCtrl.dispose();
    _hobbiesCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _newSkillCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Ganti Foto Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFC1D4B6),
                  child: Icon(Icons.camera_alt, color: Color(0xFF8FAA72)),
                ),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) setState(() => _imagePath = picked.path);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFC1D4B6),
                  child: Icon(Icons.photo_library, color: Color(0xFF8FAA72)),
                ),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) setState(() => _imagePath = picked.path);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _addSkill() {
    final skill = _newSkillCtrl.text.trim();
    if (skill.isEmpty) return;
    if (_skills.contains(skill)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$skill" sudah ada di daftar skill.')),
      );
      return;
    }
    setState(() {
      _skills.add(skill);
      _newSkillCtrl.clear();
    });
  }

  void _removeSkill(String skill) {
    setState(() => _skills.remove(skill));
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong!')));
      return;
    }

    final updated = widget.profile.copyWith(
      name: _nameCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      about: _aboutCtrl.text.trim(),
      education: _educationCtrl.text.trim(),
      gpa: _gpaCtrl.text.trim(),
      hobbies: _hobbiesCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      skills: List<String>.from(_skills),
      imagePath: _imagePath,
    );

    Navigator.pop(context, updated);
  }

  Widget _buildAvatar() {
    final ImageProvider img = _imagePath != null
        ? FileImage(File(_imagePath!))
        : const AssetImage('assets/images/profile.jpeg') as ImageProvider;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(radius: 55, backgroundImage: img),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _primaryGreen,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildEditCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5FAF0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF6A8A52)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: _appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Batal',
        ),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_alt_rounded, color: Color(0xFF3D5A26)),
            label: const Text(
              'Simpan',
              style: TextStyle(
                color: Color(0xFF3D5A26),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _buildAvatar()),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_camera, color: _primaryGreen),
                  label: const Text(
                    'Ganti Foto',
                    style: TextStyle(color: _primaryGreen),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildEditCard(
                icon: Icons.person_outline,
                title: 'Identitas',
                child: Column(
                  children: [
                    _field(_nameCtrl, 'Nama Lengkap'),
                    const SizedBox(height: 12),
                    _field(_titleCtrl, 'Jabatan / Status'),
                  ],
                ),
              ),

              _buildEditCard(
                icon: Icons.info_outline,
                title: 'Tentang Saya',
                child: _field(
                  _aboutCtrl,
                  'Deskripsi singkat',
                  maxLines: 3,
                  hint: 'Ceritakan tentang diri Anda...',
                ),
              ),

              _buildEditCard(
                icon: Icons.school,
                title: 'Pendidikan',
                child: Column(
                  children: [
                    _field(_educationCtrl, 'Nama Universitas'),
                    const SizedBox(height: 12),
                    _field(
                      _gpaCtrl,
                      'IPK',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ],
                ),
              ),

              _buildEditCard(
                icon: Icons.favorite_outline,
                title: 'Hobi & Minat',
                child: _field(
                  _hobbiesCtrl,
                  'Hobi & Minat',
                  hint: 'Coding • Membaca • Olahraga',
                ),
              ),

              _buildEditCard(
                icon: Icons.contact_mail_outlined,
                title: 'Kontak',
                child: Column(
                  children: [
                    _field(
                      _emailCtrl,
                      'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      _phoneCtrl,
                      'Nomor Telepon',
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              _buildEditCard(
                icon: Icons.stars_outlined,
                title: 'Skills',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _skills
                          .map(
                            (s) => Chip(
                              label: Text(s),
                              backgroundColor: const Color(0xFFDFF0D2),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => _removeSkill(s),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newSkillCtrl,
                            decoration: InputDecoration(
                              labelText: 'Tambah skill baru',
                              filled: true,
                              fillColor: const Color(0xFFF5FAF0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB8D4A0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB8D4A0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: _primaryGreen,
                                  width: 2,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                color: Color(0xFF6A8A52),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            onSubmitted: (_) => _addSkill(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addSkill,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          child: const Text('Tambah'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// HELPER WIDGETS
// =====================================================================
class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF).withOpacity(0.9),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// GALLERY
// =====================================================================
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoryPage(name: name)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const _DisplayDemo(),
      'Input' => const _InputDemo(),
      'Button' => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout' => const _LayoutDemo(),
      _ => const Center(child: Text('?')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(padding: const EdgeInsets.all(16), child: body),
    );
  }
}

// =====================================================================
// DEMO WIDGETS
// =====================================================================
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text(
          'CircleAvatar & Icon',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: const [
            CircleAvatar(child: Text('A')),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check),
            ),
            SizedBox(width: 12),
            Icon(Icons.star, color: Colors.amber, size: 40),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Tooltip', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Tooltip(
          message: 'Ini icon favorit',
          child: Icon(Icons.favorite, color: Colors.red, size: 40),
        ),
        const SizedBox(height: 16),
        const Text(
          'LinearGradient',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputDemo extends StatefulWidget {
  const _InputDemo();
  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  bool _checked = false;
  bool _switched = true;
  double _slider = 0.5;
  String? _dropdown = 'Apel';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TextField'),
        const SizedBox(height: 4),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama',
            hintText: 'Ketik nama Anda',
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        SwitchListTile(
          title: const Text('Switch'),
          value: _switched,
          onChanged: (v) => setState(() => _switched = v),
        ),
        const Text('Slider'),
        Slider(value: _slider, onChanged: (v) => setState(() => _slider = v)),
        const SizedBox(height: 8),
        const Text('Dropdown'),
        DropdownButton<String>(
          value: _dropdown,
          items: [
            'Apel',
            'Jeruk',
            'Mangga',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _dropdown = v),
        ),
      ],
    );
  }
}

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        const SizedBox(height: 8),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Dengan Icon'),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite, color: Colors.red),
        ),
      ],
    );
  }
}

class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halo dari SnackBar!')),
            );
          },
          child: const Text('Tampilkan SnackBar'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Yakin ingin lanjut?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Tampilkan Dialog'),
        ),
        const SizedBox(height: 16),
        const Text('Progress Indicator:'),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 0.6),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stack — widget bertumpuk'),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              Container(width: double.infinity, color: Colors.blue.shade100),
              Positioned(
                top: 12,
                left: 12,
                child: Container(width: 50, height: 50, color: Colors.red),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: Icon(Icons.star, size: 40, color: Colors.amber),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Wrap — auto-pindah baris saat penuh'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            8,
            (i) => Container(
              padding: const EdgeInsets.all(12),
              color: Colors.teal.shade100,
              child: Text('Item ${i + 1}'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('GridView (count: 3)'),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              6,
              (i) => Container(
                color: Colors.purple.shade100,
                alignment: Alignment.center,
                child: Text('${i + 1}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
