import 'package:flutter/material.dart';
import '../../models/purchase.dart';
import '../../services/purchase_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  List<Purchase> _purchases = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final data = await PurchaseService.getHistory();
      setState(() {
        _purchases = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to load purchase history'),
                backgroundColor: AppTheme.danger));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Purchase History')),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.cyan));
    }
    if (_purchases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined,
                color: AppTheme.textMuted, size: 48),
            const SizedBox(height: 16),
            const Text('No purchases yet',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('Your purchase history will appear here.',
                style: TextStyle(
                    color: AppTheme.textMuted, fontSize: 13)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: AppTheme.cyan,
      backgroundColor: AppTheme.bgCard,
      onRefresh: _fetch,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _purchases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _PurchaseCard(purchase: _purchases[i]),
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  final Purchase purchase;

  const _PurchaseCard({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final date = purchase.purchasedAt.isNotEmpty
        ? purchase.purchasedAt.substring(0, 10)
        : '-';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider)),
      child: Row(
        children: [
          // Image
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ResourceImage(
                  imageFilename: purchase.image,
                  width: 64, height: 64,
                  fit: BoxFit.cover)),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    purchase.name ?? 'Unknown Resource',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 4),
                if (purchase.type != null)
                  TypeBadge(type: purchase.type!),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _MetaTag(Icons.shopping_bag_outlined,
                        'x${purchase.quantity}'),
                    const SizedBox(width: 12),
                    _MetaTag(Icons.calendar_today_outlined, date),
                  ],
                ),
              ],
            ),
          ),

          // Total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total',
                  style: TextStyle(
                      color: AppTheme.textMuted, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                  'Rp ${purchase.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w500,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaTag(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textMuted, fontSize: 12)),
      ],
    );
  }
}