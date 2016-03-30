import QtQuick 2.0
import Sailfish.Silica 1.0


BackgroundItem
{
      
    id: dataCol
    property alias widgetName: nameLabel.text
    Switch
    {
        id: applySwitch
        anchors.left: parent.left
        Binding
        {
            target: applySwitch
            property: 'checked'
            value: model.isVisible
        }
        onClicked:{
            var item = listView.model.get(model.index)
            item.isVisible = checked ? 1 : 0
        }
    }
    Label 
    {
        id: nameLabel
        anchors.left: applySwitch.right
        anchors.verticalCenter: applySwitch.verticalCenter
    }
}
