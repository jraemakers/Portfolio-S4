import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battery_plus/battery_plus.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onLocaleChange;

  const HomeScreen({super.key, required this.onLocaleChange});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Battery _battery;
  int _batteryLevel = 0;
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _battery = Battery();
    _getBatteryLevel();

    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      _getBatteryLevel();
    });
  }

  Future<void> _getBatteryLevel() async {
    final batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Color _getProgressBarColor(int percentage) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getBatteryStatusLabel(int batteryLevel) {
    if (batteryLevel >= 80) {
      return AppLocalizations.of(context)!.good;
    } else if (batteryLevel >= 20) {
      return AppLocalizations.of(context)!.moderate;
    } else {
      return AppLocalizations.of(context)!.low;
    }
  }

  String calculateTimeToEmpty(int batteryLevel) {
    int batteryCapacity = 5000; // mAh
    int averageConsumption = 135; // mA
    final hoursToEmpty =
        (batteryLevel / 100) * batteryCapacity / averageConsumption;

    if (hoursToEmpty.isInfinite || hoursToEmpty.isNaN) {
      return 'N/A';
    }

    final hours = hoursToEmpty.floor();
    final minutes = ((hoursToEmpty - hours) * 60).round();

    return '$hours ${AppLocalizations.of(context)!.hours}, $minutes ${AppLocalizations.of(context)!.minutes}';
  }

  String calculateTimeToFullCharge(int currentBatteryLevel) {
    double deviceBatteryCapacity = 5; //Ah
    double maxChargingVolt = 9; //Volt
    double maxChargingWatts = 25; //Watts
    double maxChargingRate = maxChargingWatts / maxChargingVolt; //Ampere
    double chargingEfficiency = 0.7; //70%
    if (currentBatteryLevel == 100) {
      return 'N/A';
    }
    int DoD = 100 - currentBatteryLevel;
    final hoursToFullCharge = (deviceBatteryCapacity * (DoD / 100)) /
        (maxChargingRate * chargingEfficiency);

    if (hoursToFullCharge.isInfinite || hoursToFullCharge.isNaN) {
      return 'N/A';
    }

    final hours = hoursToFullCharge.floor();
    final minutes = ((hoursToFullCharge - hours) * 60).round();

    return '$hours ${AppLocalizations.of(context)!.hours}, $minutes ${AppLocalizations.of(context)!.minutes}';
  }

  @override
  void dispose() {
    _batteryStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          _buildLanguageDropdown(context),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(AppLocalizations.of(context)!.helloWorld),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                '${AppLocalizations.of(context)!.batteryLevel}: $_batteryLevel%'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _batteryLevel / 100.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressBarColor(_batteryLevel),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getBatteryStatusLabel(_batteryLevel),
                  style: TextStyle(
                    color: _getProgressBarColor(_batteryLevel),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)!.empty}: ${calculateTimeToEmpty(_batteryLevel)}',
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context)!.full}: ${calculateTimeToFullCharge(_batteryLevel)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      onChanged: (String? newValue) {
        widget.onLocaleChange(newValue!);
      },
      items: AppLocalizations.supportedLocales
          .map<DropdownMenuItem<String>>((Locale locale) {
        return DropdownMenuItem<String>(
          value: locale.languageCode,
          child: Text(locale.languageCode),
        );
      }).toList(),
    );
  }
}
