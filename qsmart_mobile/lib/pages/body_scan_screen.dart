import 'package:flutter/material.dart';
import '../models/tension_display_point.dart';
import '../services/body_map_service.dart';
import '../widgets/body_scanner_map.dart';
import '../theme/qsmart_theme.dart';

class BodyScanScreen extends StatefulWidget {
  const BodyScanScreen({super.key});

  @override
  State<BodyScanScreen> createState() => _BodyScanScreenState();
}

class _BodyScanScreenState extends State<BodyScanScreen> {
  final BodyMapService _service = BodyMapService();
  late Future<List<TensionDisplayPoint>> _tensionDataFuture;

  // If non-null, this is the sessionId we should load readings for.
  String? _sessionId;
  bool _initialized = false;

  BodySide _currentSide = BodySide.front;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    // Args can be:
    // - String (a specific sessionId – from NewSessionPage)
    // - null (when opened from dashboard "View Body Tension Map")
    final Object? args = ModalRoute.of(context)?.settings.arguments;

    if (args is String) {
      _sessionId = args;
    } else {
      _sessionId = null;
    }

    _tensionDataFuture = (_sessionId != null)
        ? _service.fetchTensionPointsForSession(_sessionId!)
        : _service.fetchTensionPointsForLastSession();
  }

  void _reloadData() {
    setState(() {
      _tensionDataFuture = (_sessionId != null)
          ? _service.fetchTensionPointsForSession(_sessionId!)
          : _service.fetchTensionPointsForLastSession();
    });
  }

  void _setSide(BodySide side) {
    setState(() {
      _currentSide = side;
      final int pageIndex = side == BodySide.front ? 0 : 1;
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.royalBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        title: const Text('Tension Map Scanner'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadData,
            tooltip: 'Rescan Body',
          ),
        ],
      ),
      body: FutureBuilder<List<TensionDisplayPoint>>(
        future: _tensionDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 16),
                  Text(
                    'Scanning...',
                    style: TextStyle(color: AppColors.offWhite),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load tension data.\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final List<TensionDisplayPoint> data =
              snapshot.data ?? <TensionDisplayPoint>[];

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'No previous session data found.\nStart a new session to see your body map.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.offWhite),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Front / Back toggle
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(20),
                    isSelected: [
                      _currentSide == BodySide.front,
                      _currentSide == BodySide.back,
                    ],
                    onPressed: (index) {
                      _setSide(index == 0 ? BodySide.front : BodySide.back);
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Front'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Back'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentSide =
                            index == 0 ? BodySide.front : BodySide.back;
                      });
                    },
                    children: [
                      BodyScannerMap(
                        tensionData: data,
                        side: BodySide.front,
                        imageAsset: 'assets/images/frontbody.png',
                      ),
                      BodyScannerMap(
                        tensionData: data,
                        side: BodySide.back,
                        imageAsset: 'assets/images/backbody.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
