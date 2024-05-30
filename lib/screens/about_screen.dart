import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/main_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black87;

    return MainScaffold(
      title: 'Hakkında',
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: backgroundColor,
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/applogo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Cüzdanlık Uygulaması',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Bu uygulama kişisel finans yönetimi için tasarlanmıştır. '
                    'Giderlerinizi takip etmenizi sağlar, bütçenizi kontrol altında tutmanıza yardımcı olur.',
                    style: TextStyle(fontSize: 18.0, color: subtitleColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Özellikler:',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            const FeatureList(),
            const SizedBox(height: 24.0),
            Text(
              'Geliştirici:',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Anıl Karaca',
              style: TextStyle(
                fontSize: 18.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildDeveloperInfoSection(textColor, subtitleColor),
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
      showSettingsIcon: true,
    );
  }

  Widget _buildDeveloperInfoSection(Color textColor, Color subtitleColor) {
    final developerLinks = [
      {'label': 'X:', 'url': 'https://x.com/anilkaraca17', 'icon': Icons.link},
      {'label': 'LinkedIn:', 'url': 'https://www.linkedin.com/in/anil-karaca/', 'icon': Icons.link},
      {'label': 'Website:', 'url': 'https://anilkaraca.com/', 'icon': Icons.link},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: developerLinks.map((link) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Icon(link['icon'] as IconData, color: textColor),
              const SizedBox(width: 8.0),
              Text(
                link['label'] as String,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: GestureDetector(
                  onTap: () => _launchURL(link['url'] as String),
                  child: Text(
                    link['url'] as String,
                    style: TextStyle(fontSize: 16.0, color: subtitleColor, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FeatureList extends StatelessWidget {
  const FeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;
    const iconColor = Color.fromARGB(255, 34, 197, 94);

    final features = [
      {'icon': Icons.add, 'text': 'Gider ekleyebilme'},
      {'icon': Icons.category, 'text': 'Harcama kategorileri ve alt kategorileri'},
      {'icon': Icons.pie_chart, 'text': 'Aylık harcama dağılımı raporları'},
      {'icon': Icons.dark_mode, 'text': 'Karanlık mod desteği'},
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(feature['icon'] as IconData, color: iconColor),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  feature['text'] as String,
                  style: TextStyle(fontSize: 18.0, color: textColor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
