
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Page 
{
    id: page
    allowedOrientations: Orientation.All
    Label
    {
        text: "There is an error with one of the widgets, changes have not been applied."
        anchors.centerIn: parent
        width: parent.width
        wrapMode: Text.WordWrap
    }
    height :Screen.height 
    width: Screen.width
}