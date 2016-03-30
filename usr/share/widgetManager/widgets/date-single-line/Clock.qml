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

Item
{
    id: clock

    property alias time: timeText.time
    property alias color: timeText.color
    property bool followPeekPosition
    property alias updatesEnabled: timeText.updatesEnabled

    width: month.width
    height: month.font.pixelSize
    baselineOffset: timeText.y + timeText.baselineOffset

    ClockItem
    {
        id: timeText
        color: Theme.primaryColor
        visible: false
    }

    Text
    {
        id: month
        anchors
        {
            bottom: parent.top
            bottomMargin: -month.font.pixelSize
            horizontalCenter: parent.horizontalCenter
        }
        color: timeText.color
        font
        {
            pixelSize: Theme.fontSizeExtraLarge * 1.1
            family: Theme.fontFamily
        }

        text:{
            var day = Format.formatDate(time, Format.WeekdayNameStandalone)
            return day[0].toUpperCase() + day.substring(1) + " " + Format.formatDate(time, Format.DateMediumWithoutYear)
        }
    }
}
