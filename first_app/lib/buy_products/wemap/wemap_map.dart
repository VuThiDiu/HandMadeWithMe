// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';
import 'dart:math';

import 'package:first_app/buy_products/wemap/ui.dart';
import 'package:first_app/buy_products/wemap/wemapgl_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'camera.dart';
import 'controller.dart';

typedef void MapCreatedCallback(WeMapController controller);

class WeMap extends StatefulWidget {
  WeMap({
    @required this.initialCameraPosition,
    this.onMapCreated,
    this.onStyleLoadedCallback,
    this.gestureRecognizers,
    this.compassEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.styleString,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.trackCameraPosition = false,
    this.myLocationEnabled = false,
    this.myLocationTrackingMode = MyLocationTrackingMode.None,
    this.myLocationRenderMode = MyLocationRenderMode.COMPASS,
    this.logoViewMargins = const Point(0, 0),
    this.compassViewPosition,
    this.compassViewMargins,
    this.attributionButtonMargins,
    this.onMapClick,
    this.onUserLocationUpdated,
    this.onMapLongClick,
    this.onCameraTrackingDismissed,
    this.onCameraTrackingChanged,
    this.onCameraIdle,
    this.onMapIdle,
    this.reverse = false,
    this.showReverseClearButton = true,
    this.onPlaceCardClose,
    this.destinationIcon
  }) : assert(initialCameraPosition != null);

  /// default is false,
  /// if true the Place Card at the bottom will be called.
  /// If reverse is true, you need to declare onCardClose.
  final bool reverse;
  final bool showReverseClearButton;

  /// The callback function that is called when close this place card.
  /// If reverse is true, you need to declare onCardClose.
  final void Function() onPlaceCardClose;

  /// Please note: you should only add annotations (e.g. symbols or circles) after `onStyleLoadedCallback` has been called.
  final MapCreatedCallback onMapCreated;

  /// Called when the map style has been successfully loaded and the annotation managers have been enabled.
  /// Please note: you should only add annotations (e.g. symbols or circles) after this callback has been called.
  final OnStyleLoadedCallback onStyleLoadedCallback;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  String styleString;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// True if you want to be notified of map camera movements by the WeMapController. Default is false.
  ///
  /// If this is set to true and the user pans/zooms/rotates the map, WeMapController (which is a ChangeNotifier)
  /// will notify it's listeners and you can then get the new WeMapController.cameraPosition.
  final bool trackCameraPosition;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// The mode used to let the map's camera follow the device's physical location.
  /// `myLocationEnabled` needs to be true for values other than `MyLocationTrackingMode.None` to work.
  final MyLocationTrackingMode myLocationTrackingMode;

  /// The mode to render the user location symbol
  final MyLocationRenderMode myLocationRenderMode;

  final Point logoViewMargins;

  final CompassViewPosition compassViewPosition;

  final Point compassViewMargins;

  final Point attributionButtonMargins;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  final OnMapClickCallback onMapClick;
  final OnMapClickCallback onMapLongClick;

  /// While the `myLocationEnabled` property is set to `true`, this method is
  /// called whenever a new location update is received by the map view.
  final OnUserLocationUpdated onUserLocationUpdated;

  /// Called when the map's camera no longer follows the physical device location, e.g. because the user moved the map
  final OnCameraTrackingDismissedCallback onCameraTrackingDismissed;

  /// Called when the location tracking mode changes
  final OnCameraTrackingChangedCallback onCameraTrackingChanged;

  // Called when camera movement has ended.
  final OnCameraIdleCallback onCameraIdle;

  /// Called when map view is entering an idle state, and no more drawing will
  /// be necessary until new data is loaded or there is some interaction with
  /// the map.
  /// * No camera transitions are in progress
  /// * All currently requested tiles have loaded
  /// * All fade/transition animations have completed
  final OnMapIdleCallback onMapIdle;

  final String destinationIcon;

  @override
  State createState() => _WeMapState();
}

class _WeMapState extends State<WeMap> {
  final Completer<WeMapController> _controller =
  Completer<WeMapController>();

  _WeMapOptions _wemapMapOptions;
  final WeMapGlPlatform _WeMapGlPlatform = WeMapGlPlatform.createInstance();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialCameraPosition': widget.initialCameraPosition?.toMap(),
      'options': _WeMapOptions.fromWidget(widget).toMap(),
      'logoViewMarginsY': 10 + widget.logoViewMargins.y.toDouble(),
      'logoViewMarginsX': 4 + widget.logoViewMargins.x.toDouble(),

    };
    return _WeMapGlPlatform.buildView(
        creationParams, onPlatformViewCreated, widget.gestureRecognizers);
  }

  @override
  void initState() {
    super.initState();
    if(widget.styleString == null)
      widget.styleString = WeMapStyles.WEMAP_VECTOR_STYLE;
    _wemapMapOptions = _WeMapOptions.fromWidget(widget);
  }

  @override
  void didUpdateWidget(WeMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final _WeMapOptions newOptions = _WeMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates =
    _wemapMapOptions.updatesMap(newOptions);
    _updateOptions(updates);
    _wemapMapOptions = newOptions;
  }

  void _updateOptions(Map<String, dynamic> updates) async {
    if (updates.isEmpty) {
      return;
    }
    final WeMapController controller = await _controller.future;
    controller.updateMapOptions(updates);
  }

  Future<void> onPlatformViewCreated(int id) async {
    WeMapGlPlatform.addInstance(id, _WeMapGlPlatform);
    final WeMapController controller = WeMapController.init(
        id,
        widget.initialCameraPosition,
        onStyleLoadedCallback: () {
          if (_controller.isCompleted) {
            widget.onStyleLoadedCallback();
          } else {
            _controller.future.then((_) => widget.onStyleLoadedCallback());
          }
        },
        onMapClick: widget.onMapClick,
        onUserLocationUpdated: widget.onUserLocationUpdated,
        onMapLongClick: widget.onMapLongClick,
        onCameraTrackingDismissed: widget.onCameraTrackingDismissed,
        onCameraTrackingChanged: widget.onCameraTrackingChanged,
        onCameraIdle: widget.onCameraIdle,
        onMapIdle: widget.onMapIdle
    );
    await WeMapController.initPlatform(id);
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated(controller);
    }
  }
}

/// Configuration options for the WeMaps user interface.
///
/// When used to change configuration, null values will be interpreted as
/// "do not change this configuration option".
class _WeMapOptions {
  _WeMapOptions({
    this.compassEnabled,
    this.cameraTargetBounds,
    this.styleString,
    this.minMaxZoomPreference,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.trackCameraPosition,
    this.zoomGesturesEnabled,
    this.myLocationEnabled,
    this.myLocationTrackingMode,
    this.myLocationRenderMode,
    this.logoViewMargins,
    this.compassViewPosition,
    this.compassViewMargins,
    this.attributionButtonMargins,
  });

  static _WeMapOptions fromWidget(WeMap map) {
    return _WeMapOptions(
      compassEnabled: map.compassEnabled,
      cameraTargetBounds: map.cameraTargetBounds,
      styleString: map.styleString,
      minMaxZoomPreference: map.minMaxZoomPreference,
      rotateGesturesEnabled: map.rotateGesturesEnabled,
      scrollGesturesEnabled: map.scrollGesturesEnabled,
      tiltGesturesEnabled: map.tiltGesturesEnabled,
      trackCameraPosition: map.trackCameraPosition,
      zoomGesturesEnabled: map.zoomGesturesEnabled,
      myLocationEnabled: map.myLocationEnabled,
      myLocationTrackingMode: map.myLocationTrackingMode,
      myLocationRenderMode: map.myLocationRenderMode,
      logoViewMargins: map.logoViewMargins,
      compassViewPosition: map.compassViewPosition,
      compassViewMargins: map.compassViewMargins,
      attributionButtonMargins: map.attributionButtonMargins,
    );
  }

  final bool compassEnabled;

  final CameraTargetBounds cameraTargetBounds;

  final String styleString;

  final MinMaxZoomPreference minMaxZoomPreference;

  final bool rotateGesturesEnabled;

  final bool scrollGesturesEnabled;

  final bool tiltGesturesEnabled;

  final bool trackCameraPosition;

  final bool zoomGesturesEnabled;

  final bool myLocationEnabled;

  final MyLocationTrackingMode myLocationTrackingMode;

  final MyLocationRenderMode myLocationRenderMode;

  final Point logoViewMargins;

  final CompassViewPosition compassViewPosition;

  final Point compassViewMargins;

  final Point attributionButtonMargins;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> optionsMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        optionsMap[fieldName] = value;
      }
    }

    List<dynamic> pointToArray(Point fieldName) {
      if (fieldName != null) {
        return <dynamic>[fieldName.x, fieldName.y];
      }

      return null;
    }

    addIfNonNull('compassEnabled', compassEnabled);
    addIfNonNull('cameraTargetBounds', cameraTargetBounds?.toJson());
    addIfNonNull('styleString', styleString);
    addIfNonNull('minMaxZoomPreference', minMaxZoomPreference?.toJson());
    addIfNonNull('rotateGesturesEnabled', rotateGesturesEnabled);
    addIfNonNull('scrollGesturesEnabled', scrollGesturesEnabled);
    addIfNonNull('tiltGesturesEnabled', tiltGesturesEnabled);
    addIfNonNull('zoomGesturesEnabled', zoomGesturesEnabled);
    addIfNonNull('trackCameraPosition', trackCameraPosition);
    addIfNonNull('myLocationEnabled', myLocationEnabled);
    addIfNonNull('myLocationTrackingMode', myLocationTrackingMode?.index);
    addIfNonNull('myLocationRenderMode', myLocationRenderMode?.index);
    addIfNonNull('logoViewMargins', pointToArray(logoViewMargins));
    addIfNonNull('compassViewPosition', compassViewPosition?.index);
    addIfNonNull('compassViewMargins', pointToArray(compassViewMargins));
    addIfNonNull(
        'attributionButtonMargins', pointToArray(attributionButtonMargins));
    return optionsMap;
  }

  Map<String, dynamic> updatesMap(_WeMapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();
    return newOptions.toMap()
      ..removeWhere(
              (String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
