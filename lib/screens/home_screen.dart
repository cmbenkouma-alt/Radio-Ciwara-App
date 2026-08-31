import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../config/radio_config.dart';
import '../services/radio_service.dart';
import 'caster_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RadioService _radio = RadioService.instance;
  bool _loading = false;
  String _status = 'Prêt à écouter la radio';

  @override
  void initState() {
    super.initState();
    _radio.player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        if (state == PlayerState.playing) {
          _status = '🔴 RADIO CIWARA — EN DIRECT';
        } else if (state == PlayerState.paused) {
          _status = 'Radio en pause';
        } else if (state == PlayerState.stopped) {
          _status = 'Prêt à écouter la radio';
        }
      });
    });

    _radio.player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _status = 'Le flux est terminé ou indisponible.');
    });
  }

  Future<void> _toggleRadio() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      final state = _radio.player.state;
      if (state == PlayerState.playing) {
        await _radio.pause();
      } else {
        await _radio.play();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = '❌ Impossible de démarrer le flux.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Le serveur radio ne répond pas ou le flux n’est pas accessible.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _radio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFF09090B),
              title: const Text(
                'RADIO CIWARA',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              actions: [
                IconButton(
                  tooltip: 'Lecteur Caster.fm',
                  icon: const Icon(Icons.web),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CasterPlayerScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C2BDD), Color(0xFFA5163E)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C2BDD).withOpacity(.35),
                            blurRadius: 45,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.radio,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      RadioConfig.stationName,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${RadioConfig.frequency} • ${RadioConfig.city}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _status,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: FilledButton.icon(
                              onPressed: _toggleRadio,
                              icon: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : StreamBuilder<PlayerState>(
                                      stream: _radio.player.onPlayerStateChanged,
                                      builder: (_, snapshot) {
                                        final playing =
                                            snapshot.data == PlayerState.playing;
                                        return Icon(
                                          playing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                        );
                                      },
                                    ),
                              label: StreamBuilder<PlayerState>(
                                stream: _radio.player.onPlayerStateChanged,
                                builder: (_, snapshot) {
                                  final playing =
                                      snapshot.data == PlayerState.playing;
                                  return Text(
                                    playing
                                        ? 'PAUSE'
                                        : 'ÉCOUTER EN DIRECT',
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CasterPlayerScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.web),
                      label: const Text('Ouvrir le lecteur Caster.fm'),
                    ),
                    const SizedBox(height: 28),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Radio Ciwara',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Votre voix, votre radio, votre communauté.',
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
