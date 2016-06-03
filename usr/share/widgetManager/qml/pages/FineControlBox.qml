import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Item 
{
    id: fcBox
    ConfigurationGroup
    {
        id: widgetSettings
        path: "/desktop/lipstick-jolla-home/widgetManager"
        property bool adv: false
    }

    property int xPos
    property int yPos
    property bool isVisible
    property QtObject targetIt
    property Item targetRt
    property bool isPortrait 
    
    function initialise(targetItem, targetRect) 
    {
        targetIt = targetItem
        targetRt = targetRect
    }

    MouseArea
    {
        height: fcBox.isPortrait? Screen.height:Screen.width 
        width: !fcBox.isPortrait? Screen.height:Screen.width
        enabled: fcBox.isVisible
        onClicked: isVisible = false
    }
      
    Rectangle 
    {
        width: 300
        height: 300
        color: 'black'
        opacity: 0.3
        visible: fcBox.isVisible
        Image
        {
            anchors.top: parent.top
            anchors.horizontalCenter:parent.horizontalCenter 
            width: 100
            height: 100
            source: "image://theme/icon-m-up"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetIt.y = fcBox.targetIt.y-1
                    fcBox.targetRt.y = fcBox.targetRt.y-1
                }
            }
        }
        Image
        {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter:parent.horizontalCenter 
            width: 100
            height: 100
            source: "image://theme/icon-m-down"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetIt.y = fcBox.targetIt.y+1
                    fcBox.targetRt.y = fcBox.targetRt.y+1
                }
            }
        }
        Image
        {
            anchors.right: parent.right
            anchors.verticalCenter:parent.verticalCenter 
            width: 100
            height: 100
            source: "image://theme/icon-m-right"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetIt.x = fcBox.targetIt.x+1
                    fcBox.targetRt.x = fcBox.targetRt.x+1
                }
            }
        }
        Image
        {
            anchors.left: parent.left
            anchors.verticalCenter:parent.verticalCenter 
            width: 100
            height: 100
            source: "image://theme/icon-m-left"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetIt.x = fcBox.targetIt.x-1
                    fcBox.targetRt.x = fcBox.targetRt.x-1
                }
            }
        }
    }
}