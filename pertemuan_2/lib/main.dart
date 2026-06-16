import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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
      title: 'Profile Page & Widget Gallery',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F5FA),
      ),
      home: const ProfilePage(),
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
  // Data Profil
  String name = 'Daffa Al Bani';
  String title = 'Mahasiswa Teknik Informatika';
  String bio = 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.';
  String email = 'daffaaibani56@gmail.com';
  String education = 'Universitas Pasundan — Semester 4\nIPK: 3.85';
  String location = 'Bandung, Jawa Barat';
  String skills = 'Flutter, Dart, Kotlin, Firebase, UI Design'; // Data Skills (Poin 2b)
  String? profileImagePath;

  // Data Pengalaman (Bonus)
  String expTitle = 'Freelance Flutter Developer';
  String expDesc = 'Membangun aplikasi E-Commerce sederhana menggunakan Flutter dan Firebase selama 3 bulan.';
  String? expImagePath;
  double expImageHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Halaman pengaturan sedang dalam pengembangan.'),
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
            ListTile(
              leading: const Icon(Icons.history_edu),
              title: const Text('Edit Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditExperiencePage(
                      initialTitle: expTitle,
                      initialDesc: expDesc,
                      initialImagePath: expImagePath,
                      initialImageHeight: expImageHeight,
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    expTitle = result['title']!;
                    expDesc = result['desc']!;
                    expImagePath = result['imagePath'];
                    expImageHeight = result['imageHeight'] ?? 150.0;
                  });
                }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage: profileImagePath != null
                        ? (kIsWeb ? NetworkImage(profileImagePath!) : FileImage(File(profileImagePath!)) as ImageProvider)
                        : const NetworkImage('https://github.com/identicons/app.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: _StatBox(label: 'Post', value: '12')),
                Expanded(child: _StatBox(label: 'Teman', value: '128')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),
            // Section Card (Tentang, Pendidikan, Lokasi, Kontak bisa diubah - Poin 2b)
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: bio,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: education,
            ),
            _SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: location,
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: email,
            ),
            // Section Card (Skills bisa diubah - Poin 2b)
            _SectionCard(
              icon: Icons.star,
              title: 'Skills',
              child: Wrap(
                spacing: 8,
                children: skills
                    .split(',')
                    .where((s) => s.trim().isNotEmpty)
                    .map((s) => Chip(label: Text(s.trim())))
                    .toList(),
              ),
            ),
            _SectionCard(
              icon: Icons.work,
              title: 'Pengalaman',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (expImagePath != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb 
                          ? Image.network(expImagePath!, height: expImageHeight, width: double.infinity, fit: BoxFit.cover)
                          : Image.file(File(expImagePath!), height: expImageHeight, width: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                  Text(expTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(expDesc, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(
                initialName: name,
                initialTitle: title,
                initialBio: bio,
                initialEmail: email,
                initialEducation: education,
                initialLocation: location,
                initialSkills: skills,
                initialImagePath: profileImagePath,
              ),
            ),
          );

          if (result != null && result is Map<String, String?>) {
            setState(() {
              name = result['name']!;
              title = result['title']!;
              bio = result['bio']!;
              email = result['email']!;
              education = result['education']!;
              location = result['location']!;
              skills = result['skills']!;
              profileImagePath = result['imagePath'];
            });
          }
        },
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) {},
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
// EDIT PROFILE PAGE
// =====================================================================
class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialTitle;
  final String initialBio;
  final String initialEmail;
  final String initialEducation;
  final String initialLocation;
  final String initialSkills;
  final String? initialImagePath;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialTitle,
    required this.initialBio,
    required this.initialEmail,
    required this.initialEducation,
    required this.initialLocation,
    required this.initialSkills,
    this.initialImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _eduController;
  late TextEditingController _locController;
  late TextEditingController _skillsController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _titleController = TextEditingController(text: widget.initialTitle);
    _bioController = TextEditingController(text: widget.initialBio);
    _emailController = TextEditingController(text: widget.initialEmail);
    _eduController = TextEditingController(text: widget.initialEducation);
    _locController = TextEditingController(text: widget.initialLocation);
    _skillsController = TextEditingController(text: widget.initialSkills);
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'title': _titleController.text,
      'bio': _bioController.text,
      'email': _emailController.text,
      'education': _eduController.text,
      'location': _locController.text,
      'skills': _skillsController.text,
      'imagePath': _imagePath,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveProfile)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(50),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _imagePath != null
                          ? (kIsWeb ? NetworkImage(_imagePath!) : FileImage(File(_imagePath!)) as ImageProvider)
                          : const NetworkImage('https://github.com/identicons/app.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(_nameController, 'Nama Lengkap', Icons.person),
            const SizedBox(height: 16),
            _buildTextField(_titleController, 'Pekerjaan / Status', Icons.work),
            const SizedBox(height: 16),
            _buildTextField(_bioController, 'Tentang Saya (Bio)', Icons.info, maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(_eduController, 'Pendidikan', Icons.school),
            const SizedBox(height: 16),
            _buildTextField(_locController, 'Lokasi', Icons.location_on),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email', Icons.email),
            const SizedBox(height: 16),
            _buildTextField(_skillsController, 'Skills (pisahkan dengan koma)', Icons.star),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _saveProfile, child: const Text('Simpan Perubahan')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

// =====================================================================
// EDIT EXPERIENCE PAGE
// =====================================================================
class EditExperiencePage extends StatefulWidget {
  final String initialTitle;
  final String initialDesc;
  final String? initialImagePath;
  final double initialImageHeight;

  const EditExperiencePage({
    super.key,
    required this.initialTitle,
    required this.initialDesc,
    required this.initialImageHeight,
    this.initialImagePath,
  });

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String? _imagePath;
  late double _imageHeight;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDesc);
    _imagePath = widget.initialImagePath;
    _imageHeight = widget.initialImageHeight;
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengalaman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pratinjau Gambar:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: _imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(_imagePath!, fit: BoxFit.cover)
                            : Image.file(File(_imagePath!), fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          Text('Tambah Gambar Pengalaman'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Atur Tinggi Gambar:', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _imageHeight,
              min: 100.0,
              max: 400.0,
              divisions: 30,
              label: '${_imageHeight.round()} px',
              onChanged: (double value) {
                setState(() {
                  _imageHeight = value;
                });
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Pengalaman', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Deskripsi Singkat', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'title': _titleController.text,
                    'desc': _descController.text,
                    'imagePath': _imagePath,
                    'imageHeight': _imageHeight,
                  });
                },
                child: const Text('Simpan Pengalaman'),
              ),
            ),
          ],
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
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final Widget? child;

  const _SectionCard({required this.icon, required this.title, this.content, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  if (content != null) Text(content!, style: const TextStyle(height: 1.4)),
                  if (child != null) child!,
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
// WIDGET GALLERY
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryPage(name: name)),
                );
              },
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
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: body),
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
        const Card(child: ListTile(leading: Icon(Icons.album), title: Text('Judul Item'), subtitle: Text('Sub-judul'))),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(spacing: 8, children: const [Chip(label: Text('Flutter')), Chip(label: Text('Dart')), Chip(label: Text('Mobile'))]),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text('CircleAvatar & Icon', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(children: const [
          CircleAvatar(child: Text('A')),
          SizedBox(width: 12),
          CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check)),
          SizedBox(width: 12),
          Icon(Icons.star, color: Colors.amber, size: 40),
        ]),
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
        const TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Nama', hintText: 'Ketik nama Anda')),
        const SizedBox(height: 16),
        CheckboxListTile(title: const Text('Checkbox'), value: _checked, onChanged: (v) => setState(() => _checked = v ?? false)),
        SwitchListTile(title: const Text('Switch'), value: _switched, onChanged: (v) => setState(() => _switched = v)),
        const Text('Slider'),
        Slider(value: _slider, onChanged: (v) => setState(() => _slider = v)),
        const SizedBox(height: 8),
        const Text('Dropdown'),
        DropdownButton<String>(
          value: _dropdown,
          items: ['Apel', 'Jeruk', 'Mangga'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.send), label: const Text('Dengan Icon')),
        const SizedBox(height: 8),
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite, color: Colors.red)),
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Halo dari SnackBar!')));
            },
            child: const Text('Tampilkan SnackBar')),
        const SizedBox(height: 8),
        ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Yakin ingin lanjut?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Ya')),
                  ],
                ),
              );
            },
            child: const Text('Tampilkan Dialog')),
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
              Positioned(top: 12, left: 12, child: Container(width: 50, height: 50, color: Colors.red)),
              const Positioned(bottom: 12, right: 12, child: Icon(Icons.star, size: 40, color: Colors.amber)),
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
                  padding: const EdgeInsets.all(12), color: Colors.teal.shade100, child: Text('Item ${i + 1}'))),
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
                    color: Colors.purple.shade100, alignment: Alignment.center, child: Text('${i + 1}'))),
          ),
        ),
      ],
    );
  }
}
