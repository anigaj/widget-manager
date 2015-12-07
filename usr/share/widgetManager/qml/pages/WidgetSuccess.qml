
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "file:///home/nemo/widgetManager"
import org.nemomobile.dbus 2.0

Page 
{
    id: page
    allowedOrientations: Orientation.All
   
    DBusInterface {
        id: systemdServiceIface
        bus: DBus.SessionBus
        service: 'org.freedesktop.systemd1'
        path: '/org/freedesktop/systemd1/unit/lipstick_2eservice'
        iface: 'org.freedesktop.systemd1.Unit'
    }

    PortraitWidgets
    {
        anchors.fill:parent 
        visible: false
    }
    LandscapeWidgets
    {
        anchors.fill:parent 
        visible: false
    }
    Label
    {
        text: "Restarting Homescreen"
        anchors.centerIn: parent
    }
    height :Screen.height 
    width: Screen.width

    Component.onCompleted: {
            python.call('widgets.backupLayout',[],function() {})
            systemdServiceIface.call("Restart", ["replace"])
    }
}