import 'package:calendar_date_picker2/calendar_date_picker3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final today = DateUtils.dateOnly(DateTime.now());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalendarDatePicker2 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('he', ''),
        Locale('es', ''),
        Locale('ru', ''),
      ],
      home: const MyHomePage(title: 'CalendarDatePicker2 Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(2021, 8, 10),
    DateTime(2021, 8, 13),
  ];
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [
    DateTime(today.year, today.month, 1),
    DateTime(today.year, today.month, 5),
    DateTime(today.year, today.month, 14),
    DateTime(today.year, today.month, 17),
    DateTime(today.year, today.month, 25),
  ];
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 5)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 375,
          child: ListView(
            children: <Widget>[
              _buildCalendarDialogButton(),
              _buildDefaultSingleDatePickerWithValue(),
              _buildDefaultMultiDatePickerWithValue(),
              _buildDefaultRangeDatePickerWithValue(),
              _buildCalendarWithActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker3Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker3Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker3Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  _buildCalendarDialogButton() {
    final config = CalendarDatePicker3WithActionButtonsConfig(
      calendarType: CalendarDatePicker3Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      shouldCloseDialogAfterCancelTapped: true,
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker3Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                initialValue: _dialogCalendarPickerValue,
                dialogBackgroundColor: Colors.white,
                selectableDayPredicate: (day) => !day
                    .difference(_dialogCalendarPickerValue[0]!
                        .subtract(const Duration(days: 5)))
                    .isNegative,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                setState(() {
                  _dialogCalendarPickerValue = values;
                });
              }
            },
            child: const Text('Open Calendar Dialog'),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker3Config(
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Single Date Picker (With default value)'),
        CalendarDatePicker3(
          config: config,
          initialValue: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (values) =>
              setState(() => _singleDatePickerValueWithDefaultValue = values),
          selectableDayPredicate: (day) => !day
              .difference(DateTime.now().subtract(const Duration(days: 3)))
              .isNegative,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _singleDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultMultiDatePickerWithValue() {
    final config = CalendarDatePicker3Config(
      calendarType: CalendarDatePicker3Type.multi,
      selectedDayHighlightColor: Colors.indigo,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Multi Date Picker (With default value)'),
        CalendarDatePicker3(
          config: config,
          initialValue: _multiDatePickerValueWithDefaultValue,
          onValueChanged: (values) =>
              setState(() => _multiDatePickerValueWithDefaultValue = values),
        ),
        const SizedBox(height: 10),
        Wrap(
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _multiDatePickerValueWithDefaultValue,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultRangeDatePickerWithValue() {
    final config = CalendarDatePicker3Config(
      calendarType: CalendarDatePicker3Type.range,
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Range Date Picker (With default value)'),
        CalendarDatePicker3(
          config: config,
          initialValue: _rangeDatePickerValueWithDefaultValue,
          onValueChanged: (values) =>
              setState(() => _rangeDatePickerValueWithDefaultValue = values),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _rangeDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildCalendarWithActionButtons() {
    final config = CalendarDatePicker3WithActionButtonsConfig(
      calendarType: CalendarDatePicker3Type.range,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Date Picker With Action Buttons'),
        CalendarDatePicker3WithActionButtons(
          config: config,
          initialValue: _rangeDatePickerWithActionButtonsWithValue,
          onValueChanged: (values) => setState(
              () => _rangeDatePickerWithActionButtonsWithValue = values),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                _getValueText(
                  config.calendarType,
                  _rangeDatePickerWithActionButtonsWithValue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
