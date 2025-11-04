import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Example usage in UI:
/*
class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final GoogleAdsHelper _adsHelper = GoogleAdsHelper();

  @override
  void initState() {
    super.initState();
    _adsHelper.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Your other widgets
          ElevatedButton(
            onPressed: () => _adsHelper.showInterstitialAd(),
            child: Text('Show Interstitial Ad'),
          ),
          // Banner at bottom
          _adsHelper.getBannerAdWidget(),
        ],
      ),
    );
  }
}
*/

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize size;

  const BannerAdWidget({
    super.key,
    this.adUnitId = GoogleAdsHelper.bannerAdUnitId,
    this.size = AdSize.banner,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class GoogleAdsHelper {
  static final GoogleAdsHelper _instance = GoogleAdsHelper._internal();
  factory GoogleAdsHelper() => _instance;
  GoogleAdsHelper._internal();

  static const String bannerAdUnitId =
      'ca-app-pub-39007806074550933/1026065964'; // Test Banner ID
  static const String interstitialAdUnitId =
      'ca-app-pub-3900780607450933/1409209347'; // Test Interstitial ID

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  /// Load Interstitial Ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Show Interstitial Ad
  void showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Reload after showing
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
    }
  }
}
