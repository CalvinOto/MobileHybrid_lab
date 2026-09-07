import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/resource.dart';
import '../../services/resource_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class AdminResourceFormScreen extends StatefulWidget {
  final Resource? resource;

  const AdminResourceFormScreen({super.key, this.resource});

  @override
  State<AdminResourceFormScreen> createState() =>
      _AdminResourceFormScreenState();
}

class _AdminResourceFormScreenState extends State<AdminResourceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _priceCtrl;
  File? _imageFile;
  bool _loading = false;
  bool get _isEdit => widget.resource != null;

  final List<String> _typeOptions = ['Light Cone', 'Material', 'Relic', 'Other'];
  String _selectedType = 'Light Cone';

  @override
  void initState() {
    super.initState();
    final r = widget.resource;
    _nameCtrl = TextEditingController(text: r?.name ?? '');
    _descCtrl = TextEditingController(text: r?.description ?? '');
    _stockCtrl = TextEditingController(text: r?.stock.toString() ?? '');
    _priceCtrl = TextEditingController(text: r?.price.toString() ?? '');
    if (r != null && _typeOptions.contains(r.type)) {
      _selectedType = r.type;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _stockCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      Map<String, dynamic> result;
      if (_isEdit) {
        result = await ResourceService.update(
          id: widget.resource!.id,
          name: _nameCtrl.text.trim(),
          type: _selectedType,
          description: _descCtrl.text.trim(),
          stock: int.parse(_stockCtrl.text),
          price: double.parse(_priceCtrl.text),
          imageFile: _imageFile,
          existingImage: widget.resource!.image,
        );
      } else {
        result = await ResourceService.create(
          name: _nameCtrl.text.trim(),
          type: _selectedType,
          description: _descCtrl.text.trim(),
          stock: int.parse(_stockCtrl.text),
          price: double.parse(_priceCtrl.text),
          imageFile: _imageFile,
        );
      }
      if (!mounted) return;
      if (result['status'] == 200 || result['status'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_isEdit ? 'Resource updated!' : 'Resource created!'),
            backgroundColor: AppTheme.success));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result['data']['message'] ?? 'Operation failed'),
            backgroundColor: AppTheme.danger));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Connection error'),
              backgroundColor: AppTheme.danger));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDeep,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: Text(_isEdit ? 'Edit Resource' : 'Add Resource',
            style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _imageFile != null
                              ? AppTheme.cyan
                              : AppTheme.textMuted)),
                  child: _imageFile != null
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(_imageFile!, fit: BoxFit.cover))
                      : widget.resource?.image != null
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: ResourceImage(
                          imageFilename: widget.resource!.image,
                          fit: BoxFit.cover))
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppTheme.textMuted, size: 40),
                      SizedBox(height: 8),
                      Text('Tap to pick image',
                          style: TextStyle(
                              color: AppTheme.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                    labelText: 'Resource Name',
                    prefixIcon: Icon(Icons.label_outline)),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Name is required';
                  if (v.length < 2) return 'Name must be at least 2 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Type dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: AppTheme.bgSurface,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.category_outlined)),
                items: _typeOptions
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descCtrl,
                style: const TextStyle(color: AppTheme.textPrimary),
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true),
              ),
              const SizedBox(height: 16),

              // Stock & Price
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: const InputDecoration(
                          labelText: 'Stock',
                          prefixIcon: Icon(Icons.inventory_outlined)),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final n = int.tryParse(v);
                        if (n == null || n < 0) return 'Invalid stock';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: const InputDecoration(
                          labelText: 'Price (Rp)',
                          prefixIcon: Icon(Icons.payments_outlined)),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final n = double.tryParse(v);
                        if (n == null || n <= 0) return 'Invalid price';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: Icon(_isEdit
                      ? Icons.save_outlined
                      : Icons.add_circle_outline, size: 18),
                  label: _loading
                      ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppTheme.bgDeep))
                      : Text(_isEdit ? 'Update Resource' : 'Create Resource',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}