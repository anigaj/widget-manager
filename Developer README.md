#Instructions for creating a new widget for widget manager.

1) Write the qml for the widget. You can place the qml anywhere. So if it uses components from your application you can keep it with the application code.

2) Create a json file with the following attributes defined:
name: name of the widget
description: short description of the widget
path: full path to the widget qml directory, do not include the last backslash
main: The main qml object for the widget, do not include the .qml
height: The height of the widget as a fraction of the screen height. If the widget has a variable height then set this attribute as "variable"
width: The width of the widget as a fraction of the screen width. If the widget has a variable width then set this attribute as "variable"

infos;maintainer: Within the attribute  infos, the maintainer attribute specifies the name of the maintainer.

3) The json file needs to be placed in the directory /usr/share/widgetManager/widgets 