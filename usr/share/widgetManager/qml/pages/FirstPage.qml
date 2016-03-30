
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import org.nemomobile.configuration 1.0

Page 
{
    id: page
    allowedOrientations: Orientation.All
    ConfigurationGroup
    {
        id: widgetSettings
        path: "/desktop/lipstick-jolla-home/widgetManager"
        property bool debugMode: false
    }
    SilicaFlickable
    {
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

        PullDownMenu
        {
            MenuItem
            {
                id: previewPage
                text: "Apply New Layout"
                onClicked:{
                    try
                    {
                        pageStack.push(Qt.resolvedUrl("WidgetSuccess.qml"))
                    }
                    catch(e)
                    {
                        python.call('widgets.cancelLayout',[],function() {})
                        if (widgetSettings.debugMode)
                        {
                            console.log(e)
                        }
                        pageStack.push(Qt.resolvedUrl("WidgetError.qml"))
                    }
                } 
            }
            MenuItem
            {
                id: settings 
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("WidgetSettings.qml"))
            }
        }
    }
    onStatusChanged: {
        if(status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("ArrangeWidgets.qml")) 
    }
    
}