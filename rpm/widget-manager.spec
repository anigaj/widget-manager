Name:          widget-manager
Version:       0.1
Release:       1
Summary:       Lock screen patch
Group:         System/Patches
Vendor:        Anant Gajjar
Distribution:  SailfishOS
Packager: Anant Gajjar
License:       GPL
Requires: patchmanager
Requires: sailfish-version >= 1.1.9
BuildArch: noarch

%description
This is a patch and application that allow the lockscreen to be configured using widget components. The patch modifies the lockscreen files to use the widget items and also removes the clock.

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
    // Do stuff specific to uninstalls
if [ -f /usr/sbin/patchmanager ]; then
/usr/sbin/patchmanager -u widget-manager || true
fi

%postun
if [ $1 = 0 ]; then
    // Do stuff specific to uninstalls
rm -rf /usr/share/patchmanager/patches/widget-manager || true
rm -rf /usr/share/widgetManager || true
rm -rf /home/nemo/widgetManager  || true 
else
if [ $1 = 1 ]; then
    // Do stuff specific to upgrades
echo "It's just upgrade"
fi
fi

%changelog
*Wed Dec 02 2015 Builder <builder@...>

0.1
- First build.
