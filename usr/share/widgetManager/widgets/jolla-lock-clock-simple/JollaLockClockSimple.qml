import QtQuick 2.0
import Sailfish.Silica 1.0
import "file:///usr/share/lipstick-jolla-home-qt5/lockscreen"

        Clock {
            id: clock


            color: lockScreen.textColor
            updatesEnabled: visible


        }
