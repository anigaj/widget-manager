
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Page 
{
    id: page
    allowedOrientations: Orientation.All
    SilicaFlickable {
    anchors.fill: parent 
    SilicaListView
    {
        id: listView
        anchors.fill: parent
        model: app.allWidgets
        delegate: WidgetItem
        {
            widgetName: model.name
        }
    } 

    Component.onCompleted: {
            python.call('widgets.getWidgets',[],function(widgets) {
                var result_length = widgets.length;
                app.allWidgets.clear();
                for (var i=0; i<result_length; ++i) {
                    app.allWidgets.append(widgets[i]);
                }
            });
    }

    PullDownMenu {
        MenuItem{
            id: previewPage
            text: "Apply New Layout"
            onClicked:{
                try {
                    pageStack.push(Qt.resolvedUrl("WidgetSuccess.qml"))
                }
                catch(e) {
            python.call('widgets.cancelLayout',[],function() {})
                    pageStack.push(Qt.resolvedUrl("WidgetError.qml"))
                }
            } 
        }
    }
}
    onStatusChanged: {
        if(status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("ArrangeWidgets.qml")) 
    }
    
}