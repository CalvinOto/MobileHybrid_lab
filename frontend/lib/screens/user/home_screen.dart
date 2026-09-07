import 'package:flutter/material.dart';

import '../../models/resource.dart';
import '../../services/auth_service.dart';
import '../../services/resource_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../screens/auth/login_screen.dart';
import 'purchase_history_screen.dart';
import 'resource_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Resource> _resources = [];
  List<Resource> _filtered = [];
  bool _loading = true;
  String _search = '';
  String _selectedType = 'All';
  String _username = '';

  final List<String> _types = ['All', 'Light Cone', 'Material', 'Relic', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = await AuthService.getUsername();
    setState(() => _username = name ?? 'Operative');
    await _fetchResources();
  }

  Future<void> _fetchResources() async {
    setState(() => _loading = true);
    try {
      final data = await ResourceService.getAll();
      setState(() {
        _resources = data;
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to load resources'),
                backgroundColor: AppTheme.danger));
      }
    }
  }

  void _applyFilter() {
    _filtered = _resources.where((r) {
      final matchSearch = r.name.toLowerCase().contains(_search.toLowerCase());
      final matchType = _selectedType == 'All' ||
          r.type.toLowerCase() == _selectedType.toLowerCase();
      return matchSearch && matchType;
    }).toList();
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honkai Star Retail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppTheme.cyan),
            tooltip: 'Purchase History',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const PurchaseHistoryScreen())),
          ),
          IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
              onPressed: _logout),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.cyan,
        backgroundColor: AppTheme.bgCard,
        onRefresh: _fetchResources,
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTypeFilter(),
            _buildResourceCount(),
            _buildContentState(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider)),
        child: Row(
          children: [
            const CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.bgSurface,
                child: Icon(Icons.person, color: AppTheme.cyan, size: 22)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,',
                    style: TextStyle(
                        color: AppTheme.textMuted, fontSize: 14)),
                Text(_username,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
              hintText: 'Search resources...',
              prefixIcon: Icon(Icons.search, color: AppTheme.cyanDim)),
          onChanged: (v) {
            setState(() {
              _search = v;
              _applyFilter();
            });
          },
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: _types.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final selected = _selectedType == _types[i];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = _types[i];
                  _applyFilter();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                    color: selected ? AppTheme.cyan : AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? AppTheme.cyan : AppTheme.textMuted)),
                child: Center(
                  child: Text(_types[i],
                      style: TextStyle(
                          color: selected
                              ? AppTheme.bgDeep
                              : AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w700)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResourceCount() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Resources',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            Text('${_filtered.length} items',
                style: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentState() {
    if (_loading) {
      return const SliverFillRemaining(
          child: Center(
              child: CircularProgressIndicator(color: AppTheme.cyan)));
    } else if (_filtered.isEmpty) {
      return const SliverFillRemaining(
          child: Center(
              child: Text('No resources found',
                  style: TextStyle(color: AppTheme.textMuted))));
    } else {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (ctx, i) => _ResourceCard(
              resource: _filtered[i],
              onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => ResourceDetailScreen(
                        resource: _filtered[i])),
              ).then((_) => _fetchResources()),
            ),
            childCount: _filtered.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
        ),
      );
    }
  }
}

class _ResourceCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onTap;

  const _ResourceCard({required this.resource, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(11)),
                child: SizedBox(
                    width: double.infinity,
                    child: ResourceImage(
                        imageFilename: resource.image,
                        fit: BoxFit.contain)),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypeBadge(type: resource.type),
                  const SizedBox(height: 6),
                  Text(
                      resource.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Rp ${resource.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Row(children: [
                        const Icon(Icons.inventory_2_outlined,
                            size: 11, color: AppTheme.textMuted),
                        const SizedBox(width: 3),
                        Text('${resource.stock}',
                            style: const TextStyle(
                                color: AppTheme.textMuted, fontSize: 11)),
                      ]),
                    ],
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