import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page 
{
    id: page
    allowedOrientations: Orientation.All
    ConfigurationGroup
    {
        id: widgetSettings
        path: "/desktop/lipstick-jolla-home/widgetManager"
        property bool showGrid: false
        property int gridSpace: 49
        property bool useAnchors: true

    }
    
    InteractionHintLabel
    {
        id:hintLabel
        text: "Long press on widget for fine control"     
        opacity: touchInteractionHint.running ? 1.0 : 0.0
                
        Behavior on opacity { FadeAnimation { duration: 800 } }
        anchors.bottom: saveButton.top
    }
 
    LongPressInteractionHint
    {
        id: touchInteractionHint
        anchors.bottomMargin: - Theme.itemSizeSmall
        loops:2
        running:false
    }

    FirstTimeUseCounter
    {
        id: counter
        limit: 2
        defaultValue: 0 // display hint three times
        key: "/desktop/lipstick-jolla-home/widgetManager/arrangeCount"
    }
    
    ListModel
    {
        id: itemModel
    }

     ListModel
    {
        id: posModel
    }
    
    Column
    {
        spacing: widgetSettings.gridSpace
        visible: widgetSettings.showGrid
        id: horLines
        Repeater
        {
            model: Math.ceil((page.height-saveButton.height)/(horLines.spacing+1))

            Rectangle
            {
                width: page.width
                height:1
                color: "yellow"
                opacity: 0.5
            }
        }
    }

    Row
    {
        spacing: widgetSettings.gridSpace
        visible: widgetSettings.showGrid
        id: verLines
        Repeater
        {  
            model:Math.ceil( (page.width)/(verLines.spacing+1))
            Rectangle
            {
                width: 1
                height:page.height-saveButton.height
                color: "yellow"
                opacity:0.5
            }
        }
    }
    Rectangle
    {
        width: page.width
        height:1
        color: "red"
        opacity: 1.0
        visible: widgetSettings.showGrid
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle
    {
        width: 1
        height:page.height-saveButton.height
        color: "red"
        opacity: 1.0
        visible: widgetSettings.showGrid
        anchors.horizontalCenter: parent.horizontalCenter
    }

    FineControlBox
    {
        id: fcBox
        isPortrait:page.isPortrait 
        z: 100
        isVisible: false
        isHorizontal: true
        visW: itemModel
    }
    
    SilicaListView
    {
        
        id: recList
        width: parent.width 
        height: parent.height - saveButton.height 
        model: itemModel
        property int yPos: 0
        cacheBuffer: 100
        delegate: Component
        {
            id:widgetDelegate
            
            Rectangle
            {
                id: rect
                height: content.height
                width: content.width
                
                x: (page.isPortrait? Screen.width: Screen.height)-content.width
                 
                color: "transparent"
                border.color: Theme.primaryColor
                
                Component.onCompleted: {
                    var item = itemModel.get(model.index)
                    var itemPos =posModel.get(model.index) 
                    item.width = Math.round(content.width)
                    item.height = Math.round(content.height)
                    itemPos.x =Math.round( x)
                    itemPos.y =Math.round(recList.yPos)
                    recList.yPos = recList.yPos + Math.round(content.height)
                }                         
                
                Loader
                {
                    id: content
                    property bool useanchors: widgetSettings.useAnchors 
                    source: model.path + "/" + model.preview+ ".qml"
                    onLoaded:{    
                        if(counter.active && model.index ==itemModel.count-1){
                            touchInteractionHint.x = rect.x + rect.width/2 -touchInteractionHint.width/2
                            touchInteractionHint.y = recList.yPos+ rect.height/2 -touchInteractionHint.height/2
                            touchInteractionHint.start()
                             counter.increase()
                        }
                    }
                }              

                MouseArea
                {
                    anchors.fill: parent
                    drag.target: rect
                    onReleased: {
                        var item = posModel.get(model.index)
                        rect.x = Math.round(rect.x)              
                        item.x = rect.x 
                        rect.y = Math.round(rect.y)
                        item.y = rect.y
                    }
                    onPressAndHold:{
                        fcBox.isVisible = true
                        var item = itemModel.get(model.index)
                        var itemPos = posModel.get(model.index)
                         fcBox.initialise (item,itemPos,rect)
                    }
                }
                
                Rectangle 
                {
                    width: 1
                    height: 20
                    color: "red"
                    opacity: 1.0
                    anchors
                    {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter 
                    }
                }
                Rectangle
                {
                    width: 20
                    height: 1
                    color: "red"
                    opacity: 1.0
                    anchors
                    {
                        left: parent.left
                        verticalCenter: parent.verticalCenter 
                    }
                }
                Rectangle 
                {
                    width: 1
                    height: 20
                    color: "red"
                    opacity: 1.0
                    anchors
                    {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle
                {
                    width: 20
                    height: 1
                    color: "red"
                    opacity: 1.0
                    anchors
                    {
                        right: parent.right
                        verticalCenter: parent.verticalCenter 
                    }
                }
            }
        }
    }
    Button 
    {
        id: saveButton
        text:{ "Save " + (page.isPortrait ? "portrait " : "landscape ") + "layout"   }
        anchors.bottom: parent.bottom
        width: parent.width

        onClicked:{
            python.call('widgets.initWidgets',[Screen.width, Screen.height, page.isPortrait],function() {})
            for( var i = 0; i < itemModel.count; ++i)
            {
                var widget = itemModel.get(i)
                var widgetPos = posModel.get(i)
                 console.log(widget.name +" " +widgetPos.x + " " + widgetPos.y)  
                python.call('widgets.appendWidget',[widgetPos.x,widgetPos.y,widget],function() {})
            }
            widgetSettings.useAnchors?  python.call('widgets.createQML',[],function(){}) :  python.call('widgets.createQMLxy',[],function(){})
        }
    }

    onStatusChanged: {
        if(status === PageStatus.Active) createRectangles() 
    }
    function createRectangles()
    {
        itemModel.clear()
        posModel.clear()
        for( var i = 0; i < app.allWidgets.count; ++i)
        {
            var widget = app.allWidgets.get(i) 
            if(widget.isVisible)
            {
               itemModel.append({name:widget.name, path:widget.path,preview:widget.preview,  height:0.0,width:0.0,hAnchor:"auto", hAnchorTo:"top", hAnchorItem:"lockscreen",  vAnchor:"auto", vAnchorTo:"right", vAnchorItem:"lockscreen"})

                posModel.append({x:0.0, y:0.0})
            }
        }  
    }
}