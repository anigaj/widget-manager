Name:          widget-manager
Version:       0.3
Release:       1
Summary:       Lock screen patch
Group:         System/Patches
Vendor:        Anant Gajjar
Distribution:  SailfishOS
Packager: Anant Gajjar
License:       GPL
Requires: patchmanager
Requires: sailfish-version >= 2.1.0
Requires: pyotherside-qml-plugin-python3-qt5
Requires: libsailfishapp-launcher
Conflicts: lockscreen-upcoming
Conflicts: sailfishos-statusbar-on-sneak-peek
Conflicts: sailfishos-show-weather-on-lockscreen
Conflicts: saifishos-analog-lockscreen-clock 
BuildArch: noarch

%description
This is a patch and application that allows the lockscreen to be configured using widget components. The patch modifies the lockscreen files to use the widget items and also removes the clock.

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
