Name:          widget-manager
Version:       0.5
Release:       1
Summary:       Lock screen patch
Group:         System/Patches
Vendor:        Anant Gajjar
Distribution:  SailfishOS
Packager: Anant Gajjar
License:       GPL
Requires: patchmanager
Requires: sailfish-version >= 3.0.1
Requires: pyotherside-qml-plugin-python3-qt5
Requires: libsailfishapp-launcher
Conflicts: lockscreen-upcoming
Conflicts: sailfishos-show-weather-on-lockscreen
Conflicts: saifishos-analog-lockscreen-clock 
BuildArch: noarch

%description
This is a patch and application that allows the lockscreen to be configured using widget components. The patch modifies the lockscreen files to use the widget items and also removes the clock amd weather indicator.

The application is used to manage the lockscreen portrait and landscape layouts. Different widgets can be used in each layout. The jolla-clock is included as a widget in the installation.

%files
/usr/share/patchmanager/patches/*
/usr/share/applications/*
/usr/share/icons/hicolor/86x86/apps/*
/usr/share/widgetManager/*

%defattr(-,nemo,-,-)
/home/nemo/widgetManager/*



%post
%preun
 
if [ -f /usr/sbin/patchmanager ]; then
/usr/sbin/patchmanager -u widget-manager || true
fi

%postun
if [ $1 = 0 ]; then

rm -rf /usr/share/patchmanager/patches/widget-manager || true
rm -rf /usr/share/widgetManager || true
rm -rf /home/nemo/widgetManager  || true 
else
if [ $1 = 1 ]; then
    
echo "It's just upgrade"
fi
fi

%changelog
*Mon Mar 14 2015 Builder <builder@...>
0.5
- Starts with current saved widgets and layout. Rotating the phone switches betwen saved portrait and landscape widgets layouts. This will work after you have first saved a layout using version 0.5. Unfortunately this won't restore layouts created with older versions.
- Patch updated to remove weather indicator
0.4-2
- Fixed patch for Kymijoki compatibility 
0.4-1
- Implemented preview of the widgets on the arrange widgets screen
- Fine control box draggable from top right corner
- Added switch in settings to turn off anchor based positioning and use x y instead
- Added custom anchor functionality in fine control box to define horizontal and vertical anchoring for each widget
-  Added settings to independently change rotation for lpm screen, lock screen and home screen
- Fixed patch for Jämsänjoki compatibility
- Added workaround, now compatible with Ultimate Statusbar patch

0.3
- Implemented a fine control box to move widgets pixel by pixel. Activated by long press.
- Fixed patch for Iijoki compatibility
0.2
- Added gridlines, configurable through settings
- Settings to control lockscreen/homescreen
- Fixed jolla clock animations
- Improved placement algorithm
- Added requirements and conflicts in spec file

0.1
- First build
