# widget-manager
Lockscreen widget manager for Sailfish

This is a patch and application that allow the lockscreen to be configured using widget components. The patch modifies the lockscreen files to use the widget items and also removes the clock.

The application is used to manage the lockscreen portrait and landscape layouts. Different widgets can be used in each layout. The jolla-clock is included as a widget in the installation.

Usage instructions:
1) Apply the widget manager patch through patch manager, this will:
   a) Remove the clock from the lockscreen and enable the widget manager code;
   b) Activate homescreen rotation;
   c) Activate statusbar on sneakpeak screen.

2) Launch the widget manager application, select the widgets to be displayed and swipe left.

3) Arrange the widgets, the arrangement is based on anchors and margins. Widgets with no fixed height/width will be labeled as variable height/width. So, if you place a widget below one that is variable height it will be anchored to the bottom and will move as the variable height widget grows. Click the save button when done.

4) Turn the phone to landscape orientation and arrange the landscape widgets, swipe right if you want to choose different widgets.

5) Once the layouts have been saved swipe back to the widget selection page and use the pull down menu to apply the layout. As this point an error check is performed and if the qml of all selected widgets is valid the homescreen will restart; otherwise an error page will be shown and the layout reverts back to the last good configuration.