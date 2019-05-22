import QtQuick 2.2
import Sailfish.Silica 1.0

Item
{
    id:widgetDelegate

    Rectangle
    {
        id: rect
        height: content.height
        width: content.width
                
        x : app.posModel.get(model.index).x
        y: app.posModel.get(model.index).y
        
        color: "transparent"
        border.color: Theme.primaryColor
                
        Component.onCompleted: {
            var item = itemModel.get(model.index)

            item.width = Math.round(content.width)
            item.height = Math.round(content.height)
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
                var item = app.posModel.get(model.index)
                rect.x = Math.round(rect.x)              
                item.x = rect.x 
                rect.y = Math.round(rect.y)
                item.y = rect.y
                console.log(app.posModel.get(model.index).x)
                console.log(app.posModel.get(model.index).y)
            }
           onPressAndHold:{
               fcBox.isVisible = true
               var item = app.itemModel.get(model.index)
                rect.x = Math.round(rect.x)              
                rect.y = Math.round(rect.y)
                         
                fcBox.initialise (item,app.posModel.get(model.index),rect)
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
        