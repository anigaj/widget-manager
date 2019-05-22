import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page 
{
    id: awPage
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
    
    Column
    {
        spacing: widgetSettings.gridSpace
        visible: widgetSettings.showGrid
        id: horLines
        Repeater
        {
            model: Math.ceil((awPage.height-saveButton.height)/(horLines.spacing+1))

            Rectangle
            {
                width: awPage.width
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
            model:Math.ceil( (awPage.width)/(verLines.spacing+1))
            Rectangle
            {
                width: 1
                height:awPage.height-saveButton.height
                color: "yellow"
                opacity:0.5
            }
        }
    }
    Rectangle
    {
        width: awPage.width
        height:1
        color: "red"
        opacity: 1.0
        visible: widgetSettings.showGrid
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle
    {
        width: 1
        height:awPage.height-saveButton.height
        color: "red"
        opacity: 1.0
        visible: widgetSettings.showGrid
        anchors.horizontalCenter: parent.horizontalCenter
    }

    FineControlBox
    {
        id: fcBox
        isPortrait:awPage.isPortrait 
        z: 100
        isVisible: false
        isHorizontal: true
        visW: app.itemModel
    }
    
    SilicaListView
    {
        
        id: recList
        width: parent.width 
        height: parent.height - saveButton.height 
        model: app.itemModel
        property int yPos: 0
        cacheBuffer: 100

        delegate: WidgetView
        {
        }
    }
    Button 
    {
        id: saveButton
        text:{ "Save " + (awPage.isPortrait ? "portrait " : "landscape ") + "layout"   }
        anchors.bottom: parent.bottom
        width: parent.width

        onClicked:{
            python.call('widgets.initWidgets',[Screen.width, Screen.height, awPage.isPortrait],function() {})
            for( var i = 0; i < itemModel.count; ++i)
            {
                var widget = app.itemModel.get(i)
                var widgetPos = app.posModel.get(i)
                 console.log(widget.name +" " +widgetPos.x + " " + widgetPos.y)  
                python.call('widgets.appendWidget',[widgetPos.x,widgetPos.y,widget],function() {})
            }
            widgetSettings.useAnchors?  python.call('widgets.createQML',[],function(){}) :  python.call('widgets.createQMLxy',[],function(){})
        }
    }

    onStatusChanged: {
        if(status === PageStatus.Active) createRectangles() 
    }
    
    onOrientationChanged: if(status === PageStatus.Active) pageStack.popAttached()
    function createRectangles()
    {
        for( var i = 0; i < app.allWidgets.count; ++i)
        {
            var widget = app.allWidgets.get(i)
            // find widget in list model
            var widgetFound = false
            var j
            for(j=0;  j  < app.itemModel.count; ++j) 
            {
                var visWidget = app.itemModel.get(j) 
                if(widget.name == visWidget.name)
                {
                    widgetFound = true
                    break
                }
            }
                 
            if(widget.isVisible && !widgetFound)
            {
               app.itemModel.append({name:widget.name, path:widget.path,preview:widget.preview,  height:widget.h,width:widget.w,hAnchor:widget.hAnchor, hAnchorTo:widget.hAnchorTo, hAnchorItem:widget.hAnchorItem,  vAnchor:widget.vAnchor, vAnchorTo:widget.vAnchorTo, vAnchorItem:widget.vAnchorItem})

               app.posModel.append({x:widget.x, y:widget.y})
            }
            else if(!widget.isVisible && widgetFound)
            {
                app.itemModel.remove(j)
                app.posModel.remove(j)
            }
        }  
    }
}