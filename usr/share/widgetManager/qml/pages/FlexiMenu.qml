import QtQuick 2.2
import Sailfish.Silica 1.0


ContextMenu
{    
    id: cMenu
    property bool isHorizontal
    property bool showAuto
    function getIndex(itemName)
    {             
        switch(itemName) {            
            case "auto": return 0
            case "top":
            case "left": return 1  
            case "horizontalCenter" :
            case "verticalCenter" : return 2  
            case "bottom":
            case "right"  : return 3  
            default: return cMenu.showAuto?  0 : 1
        }
    }
                        
    MenuItem
    {
        visible: cMenu.showAuto 
        text: "auto"
        height: Theme.itemSizeSmall/1.5 
    }
    MenuItem
    {      
         text: isHorizontal? "top" : "left"
        height: Theme.itemSizeSmall/1.5 
    }
    MenuItem
    {                   
        text:isHorizontal?  "verticalCenter" : "horizontalCenter"
        height: Theme.itemSizeSmall/1.5
    }
    MenuItem
    {                      
        text:isHorizontal? "bottom": "right"
        height: Theme.itemSizeSmall/1.5 
    }
}

