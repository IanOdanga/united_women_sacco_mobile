package com.surepesa.unitedwomensacco.united_women_mobile

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
    }
}
