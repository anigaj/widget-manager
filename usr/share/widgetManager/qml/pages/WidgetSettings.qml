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
        property bool rotateLpmscreen: true
        property bool showGrid: false
        property int gridSpace: 49
        property bool useAnchors: true
        property bool homescreenAllOrientations: true
        property bool lockscreenAllOrientations: true
        property bool lpmscreenAllOrientations: true
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight:mainCol.height 
        Column
        {
            id: mainCol
            width: parent.width
            spacing: Theme.paddingSmall
            PageHeader
            {
                title: "WidgetManager Settings"
            }
            ComboBox
            {
                id: hsCombo
                 currentIndex: !widgetManager.rotateHomescreen ? 0 :(widgetManager.homescreenAllOrientations ? 2 : 1)
                label: "Homescreen rotation:" 
 
               menu: ContextMenu {
                   MenuItem
                    {
                       text: "Portrait Only"
                    }
                    MenuItem 
                    {
                       text: "One way rotation" 
                    }
                    MenuItem 
                    {
                       text: "All"
                    }
                }
                onCurrentItemChanged: {
                   if (currentItem)
                    {
                       if(currentItem.text == "Portrait Only") widgetManager.rotateHomescreen = false
                        else if(currentItem.text == "One way rotation") 
                        {
                            widgetManager.rotateHomescreen = true
                            widgetManager.homescreenAllOrientations = false
                        }
                        else 
                        {
                             widgetManager.rotateHomescreen = true
                             widgetManager.homescreenAllOrientations = true
                        } 
                    }
                }
            }
            ComboBox 
            {
                id: lsCombo
                 currentIndex: !widgetManager.rotateLockscreen ? 0 :(widgetManager.lockscreenAllOrientations ? 2 : 1)
                label: "Lockscreen rotation:" 
 
               menu: ContextMenu {
                   MenuItem 
                    {
                       text: "Portrait Only"
                    }
                    MenuItem 
                    {
                       text: "One way rotation" 
                    }
                    MenuItem 
                    {
                       text: "All"
                    }
                }
                onCurrentItemChanged: {
                   if (currentItem) 
                    {
                       if(currentItem.text == "Portrait Only") widgetManager.rotateLockscreen = false
                        else if(currentItem.text == "One way rotation") 
                        {
                            widgetManager.rotateLockscreen = true
                            widgetManager.lockscreenAllOrientations = false
                        }
                        else 
                        {
                             widgetManager.rotateLockscreen = true
                             widgetManager.lockscreenAllOrientations = true
                        } 
                    }
                }
            }
            ComboBox 
            {
                id: lpmCombo
                 currentIndex: !widgetManager.rotateLpmscreen ? 0 :(widgetManager.lpmscreenAllOrientations ? 2 : 1)
                label: "LPM screen rotation:" 
 
                menu: ContextMenu {
                   MenuItem
                    {
                       text: "Portrait Only"
                    }
                    MenuItem 
                    {
                       text: "One way rotation" 
                    }
                    MenuItem 
                    {
                       text: "All"
                    }
                }
                onCurrentItemChanged: {
                   if (currentItem) 
                    {
                       if(currentItem.text == "Portrait Only") widgetManager.rotateLpmscreen = false
                        else if(currentItem.text == "One way rotation") 
                        {
                            widgetManager.rotateLpmscreen = true
                            widgetManager.lpmscreenAllOrientations = false
                        }
                        else 
                        {
                             widgetManager.rotateLpmscreen = true
                             widgetManager.lpmscreenAllOrientations = true
                        } 
                    }
                }
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
            TextSwitch
            {
                width: parent.width
                text: "Anchor based positioning"
                checked: widgetManager.useAnchors
                onClicked: widgetManager.useAnchors  = checked
            }
        }
    }
}