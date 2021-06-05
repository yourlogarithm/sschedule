import 'package:google_mobile_ads/google_mobile_ads.dart';

void interstitionalAd(){
  AdManagerInterstitialAd? _interstitialAd;
  AdManagerInterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdManagerAdRequest(),
      adLoadCallback: AdManagerInterstitialAdLoadCallback(
        onAdLoaded: (AdManagerInterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.show();
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (AdManagerInterstitialAd ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (AdManagerInterstitialAd ad, AdError error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to Load $error');
        },
      )
  );
}