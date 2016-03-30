
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "file:///home/nemo/widgetManager"
import org.nemomobile.dbus 2.0
import org.nemomobile.configuration 1.0

Page 
{
    id: page
    allowedOrientations: Orientation.All
    ConfigurationGroup
    {
        id: widgetSettings
        path: "/desktop/lipstick-jolla-home/widgetManager"
        property bool debugMode: false
    }   
    DBusInterface
    {
        id: systemdServiceIface
        bus: DBus.SessionBus
        service: 'org.freedesktop.systemd1'
        path: '/org/freedesktop/systemd1/unit/lipstick_2eservice'
        iface: 'org.freedesktop.systemd1.Unit'
    }

    PortraitWidgets
    {
        anchors.fill:parent 
        visible: widgetSettings.debugMode && page.isPortrait
    }
    LandscapeWidgets
    {
        anchors.fill:parent 
        visible: widgetSettings.debugMode && !page.isPortrait
    }
    Label
    {
        text: "Restarting Homescreen"
        anchors.centerIn: parent
        visible:! widgetSettings.debugMode
    }
    height :Screen.height 
    width: Screen.width

    Component.onCompleted: {
            python.call('widgets.backupLayout',[],function() {})
            if(!widgetSettings.debugMode) systemdServiceIface.call("Restart", ["replace"])
    }
}