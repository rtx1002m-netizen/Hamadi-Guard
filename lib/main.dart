
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HamadiGuardApp());
}

const bg = Color(0xFF0B1110);
const surface = Color(0xFF151F1D);
const green = Color(0xFF29E68C);
const muted = Color(0xFF9BAFA7);

class HamadiGuardApp extends StatelessWidget {
  const HamadiGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hamadi Guard',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          brightness: Brightness.dark,
        ),
      ),
      home: const GuardHome(),
    );
  }
}

class GuardHome extends StatefulWidget {
  const GuardHome({super.key});

  @override
  State<GuardHome> createState() => _GuardHomeState();
}

class _GuardHomeState extends State<GuardHome> {
  bool scanning = false;
  DateTime? lastScan;
  final List<String> results = [];

  Future<void> runScan() async {
    if (scanning) return;

    setState(() {
      scanning = true;
      results.clear();
    });

    HapticFeedback.lightImpact();

    // فحص مبدئي للإعدادات والإرشادات فقط.
    // ليس فحصًا فعليًا لجميع التطبيقات أو الفيروسات.
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      scanning = false;
      lastScan = DateTime.now();
      results.addAll([
        'اكتمل الفحص المبدئي للواجهة.',
        'لم يتم فحص ملفات التطبيقات بحثًا عن الفيروسات.',
        'راجع تحديثات النظام وقفل الشاشة يدويًا.',
        'لا توجد بيانات كافية للحكم على سلامة الهاتف بالكامل.',
      ]);
    });
  }

  void showInfo(String title, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                color: muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: green, size: 28),
            SizedBox(width: 10),
            Text(
              'Hamadi Guard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'معلومات التطبيق',
            onPressed: () => showInfo(
              'حول التطبيق',
              'Hamadi Guard يساعدك على متابعة إرشادات الأمان. '
                  'هذه النسخة لا تستبدل برنامج مكافحة فيروسات متخصصًا.',
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'مركز الأمان',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'أدوات لمتابعة أمان هاتفك',
              style: TextStyle(color: muted, fontSize: 15),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: green.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: green.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      scanning
                          ? Icons.sync_rounded
                          : Icons.shield_outlined,
                      color: green,
                      size: 55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    scanning ? 'جارٍ الفحص...' : 'فحص أمان مبدئي',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ابدأ مراجعة إرشادات الأمان المتاحة',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: scanning ? null : runScan,
                      icon: scanning
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.search_rounded),
                      label: Text(
                        scanning ? 'يرجى الانتظار' : 'ابدأ الفحص',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: const Color(0xFF062116),
                      ),
                    ),
                  ),
                  if (lastScan != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'آخر فحص: ${lastScan!.hour.toString().padLeft(2, '0')}:'
                      '${lastScan!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: muted),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 26),
            const Text(
              'أدوات الهاتف',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            ToolCard(
              icon: Icons.storage_rounded,
              title: 'تحليل التخزين',
              subtitle: 'افتح إعدادات مساحة الهاتف',
              onTap: () => showInfo(
                'تحليل التخزين',
                'هذه النسخة لا تقرأ مساحة التخزين تلقائيًا بعد. '
                    'افتح إعدادات الهاتف ثم التخزين لمراجعة المساحة '
                    'والملفات الكبيرة قبل حذف أي شيء.',
              ),
            ),
            ToolCard(
              icon: Icons.app_settings_alt_rounded,
              title: 'صلاحيات التطبيقات',
              subtitle: 'راجع الأذونات الحساسة',
              onTap: () => showInfo(
                'مراجعة الصلاحيات',
                'راجع صلاحيات الموقع والكاميرا والميكروفون '
                    'والملفات من إعدادات أندرويد. وجود صلاحية '
                    'لا يعني وحده أن التطبيق ضار.',
              ),
            ),
            ToolCard(
              icon: Icons.system_update_rounded,
              title: 'تحديثات النظام',
              subtitle: 'حافظ على تحديث هاتفك',
              onTap: () => showInfo(
                'تحديث النظام',
                'افتح الإعدادات ثم الأمان والخصوصية أو تحديث النظام، '
                    'بحسب نوع هاتفك. ثبّت التحديثات الرسمية المتاحة.',
              ),
            ),
            ToolCard(
              icon: Icons.lock_rounded,
              title: 'نصائح الحماية',
              subtitle: 'خطوات لتقليل مخاطر الاختراق',
              onTap: () => showInfo(
                'نصائح الحماية',
                '• استخدم قفل شاشة قويًا.\n'
                    '• حدّث أندرويد والتطبيقات.\n'
                    '• لا تثبّت ملفات APK مجهولة.\n'
                    '• فعّل Google Play Protect.\n'
                    '• لا تشارك رموز التحقق مع أحد.\n'
                    '• راجع الأجهزة المسجّلة في حساباتك.',
              ),
            ),

            if (results.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'نتائج الفحص المبدئي',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...results.map(
                (result) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: green,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            result,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Text(
              'تنبيه: هذه النسخة لا تثبت خلو الهاتف من الفيروسات '
              'ولا تكشف جميع أنواع الاختراق.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 12, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: green),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(color: muted),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}