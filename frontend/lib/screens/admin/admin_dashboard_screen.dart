import 'package:flutter/material.dart';
import '../../models/resource.dart';
import '../../services/auth_service.dart';
import '../../services/resource_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../screens/auth/login_screen.dart';
import 'admin_resource_form_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Resource> _resources = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final data = await ResourceService.getAll();
      setState(() {
        _resources = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  Future<bool?> _confirmDelete(Resource r) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Resource',
            style: TextStyle(color: AppTheme.danger, fontSize: 16)),
        content: Text(
            'Are you sure you want to delete "${r.name}"?',
            style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel',
                  style: TextStyle(color: AppTheme.textMuted))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppTheme.danger))),
        ],
      ),
    );
  }

  Future<void> _delete(Resource r) async {
    final confirmed = await _confirmDelete(r);
    if (confirmed != true) return;
    try {
      final result = await ResourceService.delete(r.id);
      if (!mounted) return;
      if (result['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Resource deleted'),
                backgroundColor: AppTheme.success));
        _fetch();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to delete'),
                backgroundColor: AppTheme.danger));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Connection error'),
              backgroundColor: AppTheme.danger));
    }
  }

  void _goToForm({Resource? resource}) {
    Navigator.push(context,
      MaterialPageRoute(
          builder: (_) => AdminResourceFormScreen(resource: resource)),
    ).then((_) => _fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honkai Star Retail'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
              onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          // Banner
          Container(
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
                    child: Icon(Icons.admin_panel_settings,
                        color: AppTheme.cyan, size: 22)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Admin Dashboard',
                        style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    Text('${_resources.length} resources total',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Resources',
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                TextButton.icon(
                    onPressed: () => _goToForm(),
                    icon: const Icon(Icons.add, color: AppTheme.cyan, size: 17),
                    label: const Text('Add',
                        style: TextStyle(
                            color: AppTheme.cyan,
                            fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.cyan));
    }
    if (_resources.isEmpty) {
      return const Center(
          child: Text('No resources found',
              style: TextStyle(color: AppTheme.textMuted)));
    }
    return RefreshIndicator(
      color: AppTheme.cyan,
      backgroundColor: AppTheme.bgCard,
      onRefresh: _fetch,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        itemCount: _resources.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ResourceTile(
          resource: _resources[i],
          onEdit: () => _goToForm(resource: _resources[i]),
          onDelete: () => _delete(_resources[i]),
        ),
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final Resource resource;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ResourceTile({
    required this.resource,
    required this.onEdit,
    required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider)),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ResourceImage(
                  imageFilename: resource.image,
                  width: 56, height: 56,
                  fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.name,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 4),
                TypeBadge(type: resource.type),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('Rp ${resource.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Text('Stock: ${resource.stock}',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppTheme.cyan, size: 20),
                  onPressed: onEdit),
              IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.danger, size: 20),
                  onPressed: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}