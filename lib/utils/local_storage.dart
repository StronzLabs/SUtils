import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
    static final SharedPreferencesAsync _sharedPreferences = SharedPreferencesAsync();
    final String storageName;
    String get _prefix => "${this.storageName}.";

    final Map<String, dynamic> _data = {};
    dynamic operator [](String key) => this._data[key];
    operator []=(String key, dynamic value) => this._data[key] = value;

    LocalStorage(this.storageName, Map<String, dynamic> defaults) {
        this._data.addAll(defaults);
    }

    @mustCallSuper
    Future<void> serialize() async {
        Map<String, dynamic> data = this._data.map((key, value) => MapEntry("${this._prefix}${key}", value));
        for (String key in data.keys)
            switch (data[key].runtimeType) {
                case bool:
                    LocalStorage._sharedPreferences.setBool(key, data[key]);
                    break;
                case int:
                    LocalStorage._sharedPreferences.setInt(key, data[key]);
                    break;
                case double:
                    LocalStorage._sharedPreferences.setDouble(key, data[key]);
                    break;
                case String:
                    LocalStorage._sharedPreferences.setString(key, data[key]);
                    break;
                case <String>[]:
                    LocalStorage._sharedPreferences.setStringList(key, data[key]);
                    break;
                default:
                    LocalStorage._sharedPreferences.setString(key, "OBJ${jsonEncode(data[key])}");
            }
    }

    @mustCallSuper
    Future<void> unserialize() async {
        Map<String, dynamic> data = await LocalStorage._sharedPreferences.getAll();
        data.removeWhere((String key, _) => !(key.contains(this._prefix)));
        for (String key in data.keys)
            if (key.startsWith(this._prefix)) {
                String field = key.substring(this._prefix.length);
                dynamic value = data[key];

                if (value is String && data[key].startsWith("OBJ"))
                    this._data[field] = jsonDecode(value.substring(3));
                else
                    this._data[key.substring(this._prefix.length)] = value;
            }
    }
}
