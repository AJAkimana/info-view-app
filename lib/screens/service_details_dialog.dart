import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:info_viewer/screens/service_view_info.dart';
import '../models/models.dart' as models;
import 'service_data_screen.dart';

class ServiceDetailsDialog extends StatefulWidget {
  final models.Service service;

  const ServiceDetailsDialog({super.key, required this.service});

  @override
  State<ServiceDetailsDialog> createState() => _ServiceDetailsDialogState();
}

class _ServiceDetailsDialogState extends State<ServiceDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _dropdownValues = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final paramFields = [
      ...widget.service.params.params ?? [],
      ...widget.service.params.query ?? [],
      ...widget.service.params.body ?? [],
    ];
    if (paramFields != null && paramFields.isNotEmpty) {
      for (var field in paramFields) {
        _controllers[field.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    print('Submitting form for service: ${widget.service.name}');
    setState(() => _isSubmitting = true);

    try {
      final formData = <String, dynamic>{};

      // Collect text field data
      for (var entry in _controllers.entries) {
        formData[entry.key] = entry.value.text;
      }

      // Collect dropdown data
      for (var entry in _dropdownValues.entries) {
        if (entry.value != null) {
          formData[entry.key] = entry.value;
        }
      }

      // await ApiService.submitServiceData(widget.service.id, formData);

      if (!mounted) return;

      Navigator.of(context).pop(); // Close dialog

      // Navigate to service data screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ServiceViewInfoScreen(
            service: widget.service,
            formData: formData,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _submitEmptyForm() async {
    if (!mounted) return;

    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServiceViewInfoScreen(
          service: widget.service,
          formData: const {}, // Pass empty map if no form
        ),
      ),
    );
  }

  Widget _buildFormField(models.InfoParam field) {
    final key = field.key;
    final label = field.label;
    final type = field.type ?? 'text';
    final name = field.name;
    final requiredField = field.required ?? false;
    final options = field.options?.split(',');

    switch (type.toLowerCase()) {
      case 'dropdown':
      case 'select':
        return DropdownButtonFormField<String>(
          value: _dropdownValues[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: options?.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _dropdownValues[key] = value;
            });
          },
          validator: requiredField
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$name is required';
                  }
                  return null;
                }
              : null,
        );
      case 'number':
        return TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: requiredField
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$name is required';
                  }
                  return null;
                }
              : null,
        );
      case 'email':
        return TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: requiredField
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$name is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4} 0')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }
              : null,
        );
      default:
        return TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: requiredField
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$name is required';
                  }
                  return null;
                }
              : null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paramFields = [
      ...?widget.service.params.params,
      ...?widget.service.params.query,
      ...?widget.service.params.body,
    ];
    final requiresForm = paramFields.isNotEmpty;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.service.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.service.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),

          // Tabbed Content
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Details'),
                      Tab(text: 'Overview'),
                      Tab(text: 'FAQ'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Details Tab with conditional form
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Builder(
                            builder: (context) {
                              if (requiresForm) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Please fill out the form below:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          for (var field in paramFields) ...[
                                            _buildFormField(field),
                                            const SizedBox(height: 12),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Text(
                                  'No additional information required. You can proceed to view the data.',
                                  style: TextStyle(fontSize: 16),
                                );
                              }
                            },
                          ),
                        ),
                        // Overview Tab
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(widget.service.description),
                        ),
                        // FAQ Tab
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Frequently Asked Questions:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Q: How do I use this service?'),
                              Text('A: Follow the instructions provided.'),
                              SizedBox(height: 8),
                              Text('Q: Is this service free?'),
                              Text('A: Yes, it is free for basic usage.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      final emailUri = Uri(
                        scheme: 'mailto',
                        path: 'myappbackups24@gmail.com',
                        query: 'subject=Support Request',
                      );
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      }
                    },
                    child: const Text(
                      'Need help? Contact support.',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : requiresForm
                              ? _submitForm
                              : _submitEmptyForm,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(requiresForm ? 'Submit' : 'View Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
