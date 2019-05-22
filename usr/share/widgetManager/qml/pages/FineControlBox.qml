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
        property bool useAnchors: true
    }

    property int xPos
    property int yPos
    property bool isVisible
    property QtObject targetIt
    property QtObject targetItPos
    property Item targetRt
    property ListModel visW
    property bool isPortrait
    property bool isHorizontal 
    
    function initialise(targetItem, targetItemPos, targetRect) 
    {
        targetIt = targetItem
        targetItPos = targetItemPos
        targetRt = targetRect
        targetItPos.x = targetRt.x
        targetItPos.y = targetRt.y
    }
    onIsVisibleChanged:{
        if(isVisible && custAnchors.expanded && widgetSettings.useAnchors&&counter.active  ){
            touchInteractionHint.start()
            counter.increase()
        }
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
        id:fcRect
        width: Theme.itemSizeExtraLarge*2
        height: Theme.itemSizeExtraLarge*2 
        color: 'black'
        opacity: 0.5
        visible: fcBox.isVisible
        z:2
        Image
        {
            anchors.top: parent.top
            anchors.right: parent.right 
            width: Theme.itemSizeMedium*3/4
            height: Theme.itemSizeMedium*3/4
            source: "image://theme/icon-m-dot"
            visible: fcBox.isVisible
            MouseArea
            {
                anchors.fill: parent
                drag.target: fcRect
            }
        }
        Image
        {
            anchors.top: parent.top
            anchors.horizontalCenter:parent.horizontalCenter 
            width: Theme.itemSizeMedium
            height: Theme.itemSizeMedium
            source: "image://theme/icon-m-up"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetItPos.y = fcBox.targetItPos.y-1
                    fcBox.targetRt.y = fcBox.targetRt.y-1
                }
            }
        }
        Image
        {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter:parent.horizontalCenter 
            width:  Theme.itemSizeMedium
            height: Theme.itemSizeMedium
            source: "image://theme/icon-m-down"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetRt.y = fcBox.targetRt.y+1
                    fcBox.targetItPos.y = fcBox.targetItPos.y+1
                }
            }
        }
        Image
        {
            anchors.right: parent.right
            anchors.verticalCenter:parent.verticalCenter 
            width: Theme.itemSizeMedium
            height: Theme.itemSizeMedium
            source: "image://theme/icon-m-right"
            visible: fcBox.isVisible
            
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetItPos.x = fcBox.targetItPos.x+1
                    fcBox.targetRt.x = fcBox.targetRt.x+1
                }
            }
        }
        Image
        {
            anchors.left: parent.left
            anchors.verticalCenter:parent.verticalCenter 
            width: Theme.itemSizeMedium
            height: Theme.itemSizeMedium
            source: "image://theme/icon-m-left"
            visible: fcBox.isVisible
            MouseArea
            {
                enabled:fcBox.isVisible
                anchors.fill: parent
                onClicked: {
                    fcBox.targetItPos.x = fcBox.targetItPos.x-1
                    fcBox.targetRt.x = fcBox.targetRt.x-1
                }
            }
        }
    }
    SilicaFlickable
    {
        z:1
        id: custAnchorArea
        anchors.top:fcBox.isPortrait? fcRect.bottom : fcRect.top
        anchors.left: fcBox.isPortrait?  fcRect.left: fcRect.right
        width: fcRect.width
        contentHeight: custAnchors.height
        height: custAnchors.height
         enabled: fcBox.isVisible 
        Rectangle 
        {
            id:custAncRect
            anchors.fill: parent
            color: 'black'
            opacity: 0.8
            visible:widgetSettings.useAnchors && fcBox.isVisible 
        }

        ExpandingSection
         {
            id: custAnchors
            buttonHeight:Theme.itemSizeMedium
            visible: widgetSettings.useAnchors && fcBox.isVisible
             title: "anchors"
            
            InteractionHintLabel 
            {
                id:hintLabel
                text: "Pull down to set " +(fcBox.isHorizontal?"vertical" : "horizontal")                
                opacity: touchInteractionHint.running ? 1.0 : 0.0
                Behavior on opacity { FadeAnimation { duration: 800 } }
                invert:true
                anchors.top: parent.bottom
            }
        
            TouchInteractionHint 
            {
                id: touchInteractionHint
                loops:2
                running:false
                interactionMode:TouchInteraction.Pull
                direction: TouchInteraction.Down
                anchors.verticalCenter: parent.verticalCenter
            }

            FirstTimeUseCounter 
            {
                id: counter
                limit: 2
                defaultValue: 0 // display hint three times
                key: "/desktop/lipstick-jolla-home/widgetManager/fcCount"
            }
            onExpandedChanged:{
                if(expanded&&counter.active)
                {   
                    touchInteractionHint.start()
                    counter.increase()
                }
            }
             content.sourceComponent: Column
            {
                spacing: -Theme.paddingLarge
                Connections
                {
                    target: fcBox
                    onIsHorizontalChanged:
                    {
                        anchorPos.currentIndex = fMenu.getIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchor :  fcBox.targetIt.vAnchor)
                        anchorPosItem.currentIndex = fMenuPosItem.getIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchorTo:  fcBox.targetIt.vAnchorTo)
                        anchorItem.currentIndex = anchorItem.getCurrentIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchorItem:  fcBox.targetIt.vAnchorItem)
                    }
                    onTargetItChanged:
                    {
                        anchorPos.currentIndex = fMenu.getIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchor :  fcBox.targetIt.vAnchor)
                        anchorPosItem.currentIndex = fMenuPosItem.getIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchorTo:  fcBox.targetIt.vAnchorTo)
                        anchorItem.currentIndex = anchorItem.getCurrentIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchorItem:  fcBox.targetIt.vAnchorItem)
                    }
                }
                ComboBox
                {
                     id: anchorPos
                    currentIndex: fMenu.getIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchor :  fcBox.targetIt.vAnchor)
                   label:  fcBox.isHorizontal ? "horizonal anchor": "veritical anchor"
                    menu: FlexiMenu
                    {
                        id: fMenu
                        x: 0
                        isHorizontal:  fcBox.isHorizontal
                        showAuto: true
                    }
                    onCurrentItemChanged: {
                         fcBox.isHorizontal? fcBox.targetIt.hAnchor = currentItem.text :  fcBox.targetIt.vAnchor= currentItem.text
                    }
                }
                 ComboBox
                {
                     visible: anchorPos.currentItem.text != "auto"
                     id: anchorPosItem
                     currentIndex: fMenuPosItem.getIndex( fcBox.isHorizontal? fcBox.targetIt.hAnchorTo:  fcBox.targetIt.vAnchorTo)
                    label: "to"
                    menu: FlexiMenu
                    {
                        id:fMenuPosItem
                        x: 0
                        isHorizontal:  fcBox.isHorizontal
                        showAuto: false
                    }
                    onCurrentItemChanged: {
                         fcBox.isHorizontal? fcBox.targetIt.hAnchorTo = currentItem.text :  fcBox.targetIt.vAnchorTo= currentItem.text
                    }
                }
                ComboBox
                {
                    id: anchorItem
                    visible: anchorPos.currentItem.text != "auto"
                    label: "of"
                    function getCurrentIndex (itemName)
                    {
                        for( var i=0; i < visW.count; ++i)
                        {
                            if(visW.get(i).name == itemName) return i +1
                        }
                        return 0
                    }
                    currentIndex: getCurrentIndex(fcBox.isHorizontal? fcBox.targetIt.hAnchorItem:  fcBox.targetIt.vAnchorItem)
                    onCurrentItemChanged: {
                         fcBox.isHorizontal? fcBox.targetIt.hAnchorItem = currentItem.text :  fcBox.targetIt.vAnchorItem= currentItem.text
                    }

                    menu: ContextMenu
                    {
                         x: 0 
                        MenuItem
                        {
                            text: "lockscreen"   
                            height:Theme.itemSizeSmall/1.5
                        }
                        
                        Repeater
                        {
                            model: visW
                            MenuItem
                            {
                                 visible:model.name  !=fcBox.targetIt.name 
                                text: model.name
                                height:Theme.itemSizeSmall/1.5
                    wrapMode:Text.Wrap
truncationMode: TruncationMode.None
                            }
                        }
                    }
                }
            } 
        }
            
        Rectangle
        {
            //fake pull down menu indicator
            anchors
            {
                verticalCenter: pullDownMenu.bottom 
                verticalCenterOffset: -pullDownMenu.spacing
                horizontalCenter: pullDownMenu.horizontalCenter 
            }
            color:pullDownMenu.backgroundColor
            height: Theme.itemSizeExtraSmall/20
            width: pullDownMenu.width
            visible: widgetSettings.useAnchors &&fcBox.isVisible 
        } 
        
        PullDownMenu
        {
            id: pullDownMenu
            visible: widgetSettings.useAnchors &&fcBox.isVisible
            topMargin: 0
            bottomMargin: 0
            quickSelect: true
            highlightColor: "transparent"
                
            MenuItem
            {
                text: fcBox.isHorizontal ? "Set Vertical" : "Set Horizontal"
                onClicked: fcBox.isHorizontal = !fcBox.isHorizontal
            }          
        } 
    }  
}