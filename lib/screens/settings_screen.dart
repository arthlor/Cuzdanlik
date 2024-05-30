import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import '../widgets/main_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final isDarkMode = expensesProvider.isDarkMode;

    return MainScaffold(
      title: 'Ayarlar',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Tema'),
            _buildCard(
              child: SwitchListTile(
                title: const Text(
                  'Karanlık Mod',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                value: isDarkMode,
                onChanged: (value) {
                  expensesProvider.toggleDarkMode(value);
                },
                activeColor: const Color.fromARGB(255, 34, 197, 94),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Bilgi'),
            _buildCard(
              child: ListTile(
                leading: const Icon(Icons.info, color: Color.fromARGB(255, 34, 197, 94)),
                title: const Text(
                  'Hakkında',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Veri Yönetimi'),
            _buildCard(
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Tüm Harcamaları Temizle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _showClearExpensesDialog(context, expensesProvider);
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Gizlilik'),
            _buildCard(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip, color: Color.fromARGB(255, 34, 197, 94)),
                title: const Text(
                  'Gizlilik Politikası',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _showPrivacyPolicy(context);
                },
              ),
            ),
          ],
        ),
      ),
      selectedIndex: 0,
      onItemTapped: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
        } else if (index == 1) {
          Navigator.pushNamed(context, '/reports');
        }
      },
      showSettingsIcon: false,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 34, 197, 94)),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: child,
      ),
    );
  }

  void _showClearExpensesDialog(BuildContext context, ExpensesProvider expensesProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tüm Harcamaları Temizle',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            'Bu işlem geri alınamaz. Tüm harcamalar silinecek. Emin misiniz?',
            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
          ),
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: <Widget>[
            TextButton(
              child: Text(
                'İptal',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Sil',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                expensesProvider.clearAllExpenses();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gizlilik Politikası'),
          content: SingleChildScrollView(
            child: Text(
              _privacyPolicyText,
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Kapat',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final String _privacyPolicyText = '''
Gizlilik Politikası

Bu Gizlilik Politikası, Cüzdanlık Uygulaması'nın kullanıcılarının kişisel verilerinin nasıl toplandığını, kullanıldığını, saklandığını ve korunduğunu açıklamaktadır. Bu uygulamayı kullanarak, bu politikada belirtilen şartları kabul etmiş olursunuz.

1. Toplanan Veriler
- Kişisel bilgiler: Ad, soyad, e-posta adresi gibi bilgiler kullanıcı tarafından sağlanabilir.
- Finansal bilgiler: Harcama kayıtları, bütçe bilgileri ve diğer finansal veriler kullanıcı tarafından girilir.
- Cihaz bilgileri: Uygulama kullanımına ilişkin cihaz türü, işletim sistemi ve diğer teknik bilgiler.

2. Verilerin Kullanımı
- Kullanıcı deneyimini iyileştirmek için kişisel ve finansal veriler kullanılabilir.
- İstatistiksel analizler yapmak ve uygulamanın performansını değerlendirmek için veriler analiz edilir.
- Kullanıcı taleplerini karşılamak ve destek sağlamak için veriler kullanılabilir.

3. Verilerin Saklanması ve Korunması
- Toplanan veriler güvenli sunucularda saklanır ve yetkisiz erişime karşı korunur.
- Kişisel verilerin gizliliğini korumak için gerekli teknik ve idari önlemler alınır.

4. Verilerin Paylaşımı
- Kullanıcı verileri üçüncü şahıslarla paylaşılmaz, satılmaz veya kiralanmaz.
- Yasal zorunluluklar nedeniyle veya kullanıcının onayı ile veriler paylaşılabilir.

5. Kullanıcı Hakları
- Kullanıcılar, kişisel verilerine erişim, düzeltme veya silme talebinde bulunabilirler.
- Gizlilik politikamız hakkında sorularınız veya endişeleriniz varsa bizimle iletişime geçebilirsiniz.

6. Değişiklikler
- Bu gizlilik politikası, zaman zaman güncellenebilir. Değişiklikler uygulamada duyurulacaktır.

İletişim:
Herhangi bir soru veya geri bildiriminiz için bizimle iletişime geçin: anilkaraca.com

Son Güncelleme: [30/05/2024]

Cüzdanlık
''';
}
