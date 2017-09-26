# widget-manager
Lockscreen widget manager for Sailfish

This is a patch and application that allow the lockscreen to be configured using widget components. The patch modifies the lockscreen files to use the widget items and also removes the clock.

The application is used to manage the lockscreen portrait and landscape layouts. Different widgets can be used in each layout. The jolla-clock is included as a widget in the installation.

Usage instructions:
1) Apply the widget manager patch through patch manager, this will remove the clock from the lockscreen and enable the widget manager code;

2) Launch the widget manager application, select the widgets to be displayed and swipe left.

3) Arrange the widgets, by default the arrangement is based on anchors and margins.  So, if you place a widget below one that changes height it will be anchored to the bottom and will move as the widget grows. this can be changed to x-y based positioning in settings, in which cases widgets will overlap if they grow. Click the save button when done. Long press on a widget will activate the fine control box. This allows the widget to be moved a pixel at a time and the anchors to be explicitly set. 

4) Turn the phone to landscape orientation and arrange the landscape widgets, swipe right if you want to choose different widgets.

5) Once the layouts have been saved swipe back to the widget selection page and use the pull down menu to apply the layout. At this point an error check is performed and if the qml of all selected widgets is valid the homescreen will restart; otherwise an error page will be shown and the layout reverts back to the last good configuration.