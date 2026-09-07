import 'package:flutter/material.dart';

import '../../models/resource.dart';
import '../../services/purchase_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class ResourceDetailScreen extends StatefulWidget {
  final Resource resource;

  const ResourceDetailScreen({super.key, required this.resource});

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  int _qty = 1;
  bool _buying = false;

  Future<void> _buy() async {
    if (widget.resource.stock <= 0) {
      _showSnack('Out of stock', error: true);
      return;
    }

    setState(() => _buying = true);

    try {
      final result = await PurchaseService.buy(widget.resource.id, _qty);
      if (!mounted) return;

      if (result['status'] == 201) {
        _showSnack('Purchase successful! Total: Rp ${result['data']['total_price']}');
        Navigator.pop(context);
      } else {
        _showSnack(result['data']['message'] ?? 'Purchase failed', error: true);
      }
    } catch (e) {
      _showSnack('Connection error', error: true);
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppTheme.danger : AppTheme.success,
      ),
    );
  }

  void _showBuySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => _buildBottomSheetContent(ctx, setModal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.resource;

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildImageBanner(r),
          _buildContent(r),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFab(r),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.bgDeep,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Resource Detail',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildImageBanner(Resource r) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: ResourceImage(
            imageFilename: r.image,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Resource r) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    r.name,
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: TypeBadge(type: r.type),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatChip(
                  label: 'Price',
                  value: 'Rp ${r.price.toStringAsFixed(0)}',
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Stock',
                  value: r.stock > 0 ? '${r.stock} left' : 'Out',
                  color: r.stock > 0 ? AppTheme.textSecondary : AppTheme.danger,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              r.description.isEmpty ? 'No description available.' : r.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(Resource r) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: r.stock > 0 ? AppTheme.cyan : AppTheme.textMuted,
            foregroundColor: AppTheme.bgDeep,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: r.stock > 0 ? _showBuySheet : null,
          icon: const Icon(Icons.shopping_cart_outlined, size: 18),
          label: Text(
            r.stock > 0 ? 'Buy Resource' : 'Out of Stock',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext ctx, StateSetter setModal) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Purchase',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ResourceImage(
                  imageFilename: widget.resource.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.resource.name,
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${widget.resource.price.toStringAsFixed(0)} / unit',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_qty > 1) setModal(() => _qty--);
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_qty',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () {
                      if (_qty < widget.resource.stock) {
                        setModal(() => _qty++);
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              Text(
                'Rp ${(widget.resource.price * _qty).toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppTheme.cyan,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyan,
                foregroundColor: AppTheme.bgDeep,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _buying ? null : () {
                Navigator.pop(ctx);
                _buy();
              },
              icon: const Icon(Icons.shopping_cart_checkout, size: 18),
              label: const Text(
                'Buy Now',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.cyan),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.cyan, size: 18),
      ),
    );
  }
}