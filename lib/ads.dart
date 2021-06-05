import 'package:google_mobile_ads/google_mobile_ads.dart';

void interstitionalAd({Function func = print}){
  AdManagerInterstitialAd? _interstitialAd;
  AdManagerInterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdManagerAdRequest(),
      adLoadCallback: AdManagerInterstitialAdLoadCallback(
        onAdLoaded: (AdManagerInterstitialAd ad) {
          print('Ad loaded $ad');
          _interstitialAd = ad;
          _interstitialAd!.show();
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (AdManagerInterstitialAd ad) => print('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (AdManagerInterstitialAd ad) {
              print('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
              func();
            },
            onAdFailedToShowFullScreenContent: (AdManagerInterstitialAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              func();
            },
            onAdImpression: (AdManagerInterstitialAd ad) => print('$ad impression occurred.'),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      )
  );
}