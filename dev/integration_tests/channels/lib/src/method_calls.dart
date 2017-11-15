// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/services.dart';
import 'test_step.dart';

Future<TestStepResult> methodCallJsonSuccessHandshake(dynamic payload) async {
  const MethodChannel channel =
      const MethodChannel('json-method', const JSONMethodCodec());
  return _methodCallSuccessHandshake(
      'JSON success($payload)', channel, payload);
}

Future<TestStepResult> methodCallJsonErrorHandshake(dynamic payload) async {
  const MethodChannel channel =
      const MethodChannel('json-method', const JSONMethodCodec());
  return _methodCallErrorHandshake('JSON error($payload)', channel, payload);
}

Future<TestStepResult> methodCallJsonNotImplementedHandshake() async {
  const MethodChannel channel =
      const MethodChannel('json-method', const JSONMethodCodec());
  return _methodCallNotImplementedHandshake('JSON notImplemented()', channel);
}

Future<TestStepResult> methodCallStandardSuccessHandshake(
    dynamic payload) async {
  const MethodChannel channel =
      const MethodChannel('std-method', const StandardMethodCodec());
  return _methodCallSuccessHandshake(
      'Standard success($payload)', channel, payload);
}

Future<TestStepResult> methodCallStandardErrorHandshake(dynamic payload) async {
  const MethodChannel channel =
      const MethodChannel('std-method', const StandardMethodCodec());
  return _methodCallErrorHandshake(
      'Standard error($payload)', channel, payload);
}

Future<TestStepResult> methodCallStandardNotImplementedHandshake() async {
  const MethodChannel channel =
      const MethodChannel('std-method', const StandardMethodCodec());
  return _methodCallNotImplementedHandshake(
      'Standard notImplemented()', channel);
}

Future<TestStepResult> syncMethodCallStandardSuccessHandshake(dynamic payload) async {
  const MethodChannel channel =
      const MethodChannel('std-sync-method', const StandardMethodCodec());
  return _methodCallSuccessHandshake(
      'Standard sync success($payload)', channel, payload);
}

Future<TestStepResult> syncMethodCallStandardErrorHandshake(dynamic payload) async {
  const MethodChannel channel =
      const MethodChannel('std-sync-method', const StandardMethodCodec());
  return _methodCallErrorHandshake(
      'Standard sync error($payload)', channel, payload);
}

Future<TestStepResult> syncMethodCallStandardNotImplementedHandshake() async {
  const MethodChannel channel =
      const MethodChannel('std-sync-method', const StandardMethodCodec());
  return _methodCallNotImplementedHandshake(
      'Standard sync notImplemented()', channel);
}

Future<TestStepResult> _methodCallSuccessHandshake(
  String description,
  MethodChannel channel,
  dynamic arguments,
) async {
  final List<dynamic> received = <dynamic>[];
  channel.setMethodCallHandler((MethodCall call) async {
    received.add(call.arguments);
    return call.arguments;
  });
  dynamic result = nothing;
  dynamic error = nothing;
  try {
    result = await channel.invokeMethod('success', arguments);
  } catch (e) {
    error = e;
  }
  return resultOfHandshake(
    'Method call success handshake',
    description,
    arguments,
    received,
    result,
    error,
  );
}

Future<TestStepResult> _methodCallErrorHandshake(
  String description,
  MethodChannel channel,
  dynamic arguments,
) async {
  final List<dynamic> received = <dynamic>[];
  channel.setMethodCallHandler((MethodCall call) async {
    received.add(call.arguments);
    throw new PlatformException(
        code: 'error', message: null, details: arguments);
  });
  dynamic errorDetails = nothing;
  dynamic error = nothing;
  try {
    error = await channel.invokeMethod('error', arguments);
  } on PlatformException catch (e) {
    errorDetails = e.details;
  } catch (e) {
    error = e;
  }
  return resultOfHandshake(
    'Method call error handshake',
    description,
    arguments,
    received,
    errorDetails,
    error,
  );
}

Future<TestStepResult> _methodCallNotImplementedHandshake(
  String description,
  MethodChannel channel,
) async {
  final List<dynamic> received = <dynamic>[];
  channel.setMethodCallHandler((MethodCall call) async {
    received.add(call.arguments);
    throw new MissingPluginException();
  });
  dynamic result = nothing;
  dynamic error = nothing;
  try {
    error = await channel.invokeMethod('notImplemented');
  } on MissingPluginException {
    result = null;
  } catch (e) {
    error = e;
  }
  return resultOfHandshake(
    'Method call not implemented handshake',
    description,
    null,
    received,
    result,
    error,
  );
}
