
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "pages"

ApplicationWindow
{
    id: app
    property ListModel allWidgets: ListModel {}
    property ListModel itemModel: ListModel {}
    property ListModel posModel: ListModel {}
    
    
    initialPage: Component 
    { 
        FirstPage { } 
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    Python
    {
        id: python

        Component.onCompleted: 
        {
            addImportPath(Qt.resolvedUrl('.'));
            importModule('widgets', function () {});
        }
    }
}

