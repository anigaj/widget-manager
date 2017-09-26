#Instructions for creating a new widget for widget manager.

1) Write the qml for the widget. You can place the qml anywhere. So if it uses components from your application you can keep it with the application code. For the preview qml file the Loader has a variable to indicate if anchors based positioning is being used. In the file parent.useanchors can be used to check this. For example, if your widget changes height and width with content then the full height and width of the widget could be specified if parent.useanchors was false. 

2) Create a json file with the following attributes defined:
name: name of the widget
description: short description of the widget
path: full path to the widget qml directory, do not include the last backslash
main: The main qml object for the widget, do not include the .qml
preview: The qml object that can be used to preview the widget when arraging them, do not include the .qml
infos;maintainer: Within the attribute  infos, the maintainer attribute specifies the name of the maintainer.

3) The json file needs to be placed in the directory /usr/share/widgetManager/widgets 