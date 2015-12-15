/****************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Petri M. Gerdt <petri.gerdt@jollamobile.com>
**
****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.time 1.0
import org.nemomobile.lipstick 0.1
import "file:///usr/share/lipstick-jolla-home-qt5/main"

Item {
    id: clock

    property alias time: timeText.time
    property alias color: timeText.color
    property bool followPeekPosition
    property alias updatesEnabled: timeText.updatesEnabled

    width: timeText.width
    height: timeText.font.pixelSize
    baselineOffset: timeText.y + timeText.baselineOffset

    ClockItem {
        id: timeText
        color: Theme.primaryColor
        // Ascender of the time to the top of the clock.
        anchors {
            bottom: parent.top
            bottomMargin: -timeText.font.pixelSize
            horizontalCenter: parent.horizontalCenter
        }
        font { pixelSize: Theme.fontSizeHuge * 2.0; family: Theme.fontFamilyHeading }
    }
}
