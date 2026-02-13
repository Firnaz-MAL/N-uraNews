import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../core/theme.dart';

class EditScreen extends StatefulWidget {
  final News? news;

  const EditScreen({super.key, this.news});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TextEditingController imageCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.news?.title ?? '');
    descCtrl = TextEditingController(text: widget.news?.description ?? '');
    imageCtrl = TextEditingController(text: widget.news?.imageUrl ?? '');
  }

  void _saveNews() {
    final id =
        widget.news?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final newNews = News(
      id: id,
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      imageUrl: imageCtrl.text.trim().isNotEmpty
          ? imageCtrl.text.trim()
          : 'https://picsum.photos/400/200?random',
      source: widget.news?.source ?? 'Admin',
      publishedAt:
          widget.news?.publishedAt ??
          DateTime.now().toIso8601String().split('T').first,
    );

    Navigator.pop(context, newNews);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.news != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit ? '✏️ Edit Berita' : '📰 Tambah Berita',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: titleCtrl,
                        label: 'Judul Berita',
                        icon: Icons.title,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: descCtrl,
                        label: 'Deskripsi',
                        icon: Icons.description,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: imageCtrl,
                        label: 'URL Gambar',
                        icon: Icons.image,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _saveNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6D83F2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: Text(
                    isEdit ? 'Simpan Perubahan' : 'Tambah Berita',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
