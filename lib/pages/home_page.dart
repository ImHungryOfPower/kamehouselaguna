import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'news_page.dart';
import 'inventory_page.dart';
import 'live_page.dart';


class HomePage extends StatefulWidget {
    const HomePage({super.key});


        @override
        State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
    int _index = 0;


    @override
    Widget build(BuildContext context) {
        const titles = [
            'Home',
            'Noticias',
            'Inventario',
            'Facebook',
        ];
        final pages = [
            const HomeScreen(),
            const NewsPage(),
            const InventoryPage(),
            const LivePage(),
        ];
        return Scaffold(
            appBar: AppBar(
                title: Text(titles[_index]),
            ),
            body: pages[_index],
            bottomNavigationBar: NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article), label: 'Noticias'),
                    NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Inventario'),
                    NavigationDestination(icon: Icon(Icons.facebook), selectedIcon: Icon(Icons.facebook), label: 'Facebook'),
                ],
            ),
        );
    }
}