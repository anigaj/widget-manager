import QtQuick 2.0
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

    }

    ListModel
    {
        id: itemModel
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
        y: page.height/2
    }
    Rectangle
    {
        width: 1
        height:page.height-saveButton.height
        color: "red"
        opacity: 1.0
        visible: widgetSettings.showGrid
        x: page.width/2
    }

    SilicaListView
    {
        id: recList
        width: parent.width 
        height: parent.height - saveButton.height 
        model: itemModel
        delegate: Component
        {
            id:widgetDelegate
            
            Rectangle
            {
                id: rect
                height: model.height == "variable" ? 200 : model.height*Screen.height 
                width: model.width == "variable" ? 200 : model.width* Screen.width
                x: model.x
                color: "transparent"
                border.color: Theme.primaryColor
                Label
                {
                    anchors.fill:parent
                    text: {
var t
t = model.name
if(model.width == "variable") t = t + "\nvariable width"
if(model.height == "variable") t = t +  "\nvariable height"} 
                }
                MouseArea
                {
                    anchors.fill: parent
                    drag.target: rect
                    onReleased: 
                    {
                        rect.x = rect.x - rect.x%2
                        rect.y = rect.y - rect.y%2
                        var item = itemModel.get(model.index)
                        item.x = rect.x
                        item.y = rect.y
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

        onClicked:
        {
            python.call('widgets.initWidgets',[Screen.width, Screen.height, page.isPortrait],function() {})
            for( var i = 0; i < itemModel.count; ++i)
            {
                var widget = itemModel.get(i) 
                python.call('widgets.appendWidget',[widget],function() {})
            }
            python.call('widgets.createQML',[],function(){}) 
        }
    }

    onStatusChanged: {
        if(status === PageStatus.Active) createRectangles() 
    }
    function createRectangles()
    {
        itemModel.clear()
        var yPos = parseFloat(0)
        for( var i = 0; i < app.allWidgets.count; ++i)
        {
            var widget = app.allWidgets.get(i) 
            if(widget.isVisible)
            {
               var xPos
               if (page.isPortrait) xPos = Screen.width -( widget.width == "variable" ? 200 : widget.width* Screen.width)
               else  xPos = Screen.height -( widget.width == "variable" ? 200 : widget.width* Screen.width)
               itemModel.append({name:widget.name, height:widget.height,width:widget.width,x:xPos,y:yPos})

               yPos = yPos + (widget.height == "variable" ?  200 :  parseFloat(widget.height*Screen.height)) 
            }
        }  
    }
}