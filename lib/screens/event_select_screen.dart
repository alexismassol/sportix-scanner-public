import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../models/event.dart';
import '../providers/auth_provider.dart';

class EventSelectScreen extends ConsumerStatefulWidget {
  const EventSelectScreen({super.key});

  @override
  ConsumerState<EventSelectScreen> createState() => _EventSelectScreenState();
}

class _EventSelectScreenState extends ConsumerState<EventSelectScreen> {
  List<Event> _events = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final scanService = ref.read(scanServiceProvider);
      final events = await scanService.getEvents();
      setState(() {
        _events = events;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les événements';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Événements')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: SportixColors.accentPrimary))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, color: SportixColors.textTertiary, size: 48),
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(color: SportixColors.textTertiary)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _loadEvents, child: const Text('Réessayer')),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: SportixGlass.card,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(event.title, style: const TextStyle(
                          fontWeight: FontWeight.w600, color: SportixColors.textPrimary,
                        )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${event.sportType} — ${event.location}', style: const TextStyle(
                              fontSize: 12, color: SportixColors.textTertiary,
                            )),
                            const SizedBox(height: 4),
                            Text('${event.ticketsSold}/${event.maxCapacity} billets vendus', style: const TextStyle(
                              fontSize: 12, color: SportixColors.textTertiary,
                            )),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: SportixColors.accentPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(event.sportType, style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600, color: SportixColors.accentPrimary,
                          )),
                        ),
                        onTap: () => Navigator.of(context).pop(event),
                      ),
                    );
                  },
                ),
    );
  }
}
