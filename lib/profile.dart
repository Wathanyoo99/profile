import 'package:flutter/foundation.dart'; // สำหรับเช็ก kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _pickedFile; // ใช้ XFile แทน File เพื่อให้รองรับทั่ง Web และ Mobile

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากคลังภาพ'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _pickedFile = image;
                    });
                  }
                },
              ),
              if (!kIsWeb) // เมนูถ่ายรูปแสดงเฉพาะบนมือถือ
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('ถ่ายรูปใหม่'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      setState(() {
                        _pickedFile = image;
                      });
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // ฟังก์ชันสลับการแสดงผลรูปโปรไฟล์ให้รองรับ Web และ Mobile
  ImageProvider _getProfileImage() {
    if (_pickedFile != null) {
      if (kIsWeb) {
        return NetworkImage(
          _pickedFile!.path,
        ); // บน Web ใช้ NetworkImage ดึง Blob URL
      } else {
        return AssetImage(_pickedFile!.path); // บน Mobile
      }
    }
    return const AssetImage('assets/wathan.jpg'); // รูปเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // ภาพพื้นหลัง
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                    ),
                  ),
                  child: Opacity(
                    opacity: 0.4,
                    child: Image(
                      image: const AssetImage('assets/wathan.jpg'),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                ),

                // รูปโปรไฟล์วงกลม
                Positioned(
                  top: 160,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _getProfileImage(),
                        ),
                      ),

                      // ปุ่มกล้องถ่ายรูป
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 75),

            // ส่วนเนื้อหา
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Text(
                    'Wathanyoo Chankwean',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lecturer in Computer Science Major\nSisaket Rajabhat University',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey[600],
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModernActionButton(
                        icon: Icons.facebook,
                        label: 'Social',
                        color: const Color(0xFF1877F2),
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _buildModernActionButton(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: const Color(0xFFEA4335),
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _buildModernActionButton(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        color: const Color(0xFF0F172A),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.badge_outlined, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              'เกี่ยวกับฉัน',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 1),
                        const Text(
                          'นักศึกษาสาขาวิชาวิทยาการคอมพิวเตอร์ คณะศิลปศาสตร์และวิทยาศาสตร์, มหาวิทยาลัยราชภัฏศรีสะเกษ.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF334155),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'เชี่ยวชาญการพัฒนาโปรแกรมด้วยภาษาไพธอน, การพัฒนาเว็บแอปลิเคชั่น, การจัดการและการประมวลผลข้อมูลขนาดใหญ่, และการพัฒนาโมบายแอปลิเคชั่น',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF334155),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
