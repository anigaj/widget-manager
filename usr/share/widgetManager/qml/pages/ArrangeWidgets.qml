import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All
    ListModel
    {
        id: itemModel

    }
    SilicaListView
    {
        anchors.fill: parent
        model: itemModel
        delegate: Component {
            id:widgetDelegate 
            Rectangle
            {
                id: rect
                height: model.height == "variable" ? 100 : model.height*Screen.height 
                width: model.width == "variable" ? 100 : model.width* Screen.width
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
            }
        }
    }

    Button 
    {
        text:{ "Save " + (page.isPortrait ? "portrait " : "landscape ") + "layout"   }
        anchors.bottom: parent.bottom
        width: parent.width
        //onClicked: pageStack.push(Qt.resolvedUrl("ArrangeWidgets.qml"))
        onClicked:{
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
        var yPos = 0
        for( var i = 0; i < app.allWidgets.count; ++i)
        {
            var widget = app.allWidgets.get(i) 
            if(widget.isVisible)
            {
               var xPos
               if (page.isPortrait) xPos = Screen.width -( widget.width == "variable" ? 100 : widget.width* Screen.width)
               else  xPos = Screen.height -( widget.width == "variable" ? 100 : widget.width* Screen.width)
               itemModel.append({name:widget.name, height:widget.height,width:widget.width,x:xPos,y:yPos})
               yPos = yPos + (widget.height == "variable" ?  100 : widget.height) 
            }
        }
    }
}