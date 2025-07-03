import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/service.dart' as models;

class ServiceViewInfoScreen extends StatefulWidget {
  final models.Service service;
  final Map<String, dynamic> formData;

  const ServiceViewInfoScreen({
    super.key,
    required this.service,
    required this.formData,
  });

  @override
  State<ServiceViewInfoScreen> createState() => _ServiceSubmissionScreenState();
}

class _ServiceSubmissionScreenState extends State<ServiceViewInfoScreen> {
  dynamic _response;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _submitData();
  }

  Future<void> _submitData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await ApiService.submitServiceData(widget.service.id, widget.formData);
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildDataWidget(String key, dynamic value) {
    if (value == null) return const SizedBox.shrink();
    if (value is Map<String, dynamic>) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          title: Text(_formatKey(key), style: const TextStyle(fontWeight: FontWeight.w600)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: value.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildDataWidget(entry.key, entry.value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
    if (value is List) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          title: Text(_formatKey(key), style: const TextStyle(fontWeight: FontWeight.w600)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: value.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildDataWidget('${entry.key + 1}', entry.value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_formatKey(key), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 12)),
          const SizedBox(height: 4),
          SelectableText(value.toString(), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' ')
        .trim();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Submitting data...'),
          ],
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error submitting data', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submitData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (_response == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No response received', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service information as header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.service.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Submitted form data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.service.name} Data', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...widget.formData.entries.map((entry) => _buildDataWidget(entry.key, entry.value)).toList(),
                const Divider(height: 32),
                // Response
                Text('Response', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildResponseWidget(_response),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseWidget(dynamic value) {
    if (value == null) return const SizedBox.shrink();
    if (value is Map<String, dynamic>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.entries.map((entry) {
          return _buildResponseWidgetEntry(entry.key, entry.value);
        }).toList(),
      );
    }
    if (value is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.asMap().entries.map((entry) {
          return _buildResponseWidgetEntry('${entry.key + 1}', entry.value);
        }).toList(),
      );
    }
    return _buildResponseWidgetEntry('Value', value);
  }

  Widget _buildResponseWidgetEntry(String key, dynamic value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_formatKey(key), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 12)),
          const SizedBox(height: 4),
          SelectableText(value.toString(), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _submitData),
        ],
      ),
      body: _buildBody(),
    );
  }
}