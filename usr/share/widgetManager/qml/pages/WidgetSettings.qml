import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page {
    id: page
    allowedOrientations: Orientation.All 
    ConfigurationGroup
    {
        id: widgetManager
        path: "/desktop/lipstick-jolla-home/widgetManager"
        property bool rotateHomescreen: true
        property bool rotateLockscreen: true
        property bool showGrid: false
        property int gridSpace: 49

    }

    SilicaFlickable
    {
        anchors.fill: parent 
        Column
        {
            id: mainCol
            width: parent.width
            spacing: Theme.paddingSmall
            PageHeader
            {
                title: "WidgetManager Settings"
            }
            TextSwitch
            {
                width: parent.width
                text: "Allow homescreen rotation"
                checked: widgetManager.rotateHomescreen
                onClicked: widgetManager.rotateHomescreen = checked
            }
            TextSwitch
            {
                width: parent.width
                text: "Allow lockscreen rotation"
                checked: widgetManager.rotateLockscreen
                onClicked: widgetManager.rotateLockscreen = checked
            }
            TextSwitch
            {
                width: parent.width
                text: "Show gridlines"
                checked: widgetManager.showGrid
                onClicked: widgetManager.showGrid = checked
            }
            Slider
            {
                visible: widgetManager.showGrid
                width: parent.width
                label: "Grid spacing"
                maximumValue: 200
                minimumValue: 2
                stepSize: 1
                value: widgetManager.gridSpace + 1
                valueText: value

                onValueChanged: widgetManager.gridSpace = Math.round(value-1)
                onPressAndHold: cancel()
            }
        }
    }
}