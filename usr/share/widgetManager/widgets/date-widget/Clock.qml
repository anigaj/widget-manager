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

    width: Math.max(weekday.width, month.width)
    height: weekday.font.pixelSize + month.font.pixelSize
    baselineOffset: timeText.y + timeText.baselineOffset

    ClockItem
    {
        id: timeText
        visible: false
        color: Theme.primaryColor
        // Ascender of the time to the top of the clock.
    }

    Text
    {
        id: weekday
        anchors
        {
            bottom: parent.top
            bottomMargin: -weekday.font.pixelSize
            horizontalCenter: parent.horizontalCenter
        }
        color: timeText.color
        font
        { 
            pixelSize: Theme.fontSizeLarge
            family: Theme.fontFamily
        }
        text: {
            var day = Format.formatDate(time, Format.WeekdayNameStandalone)
            return day[0].toUpperCase() + day.substring(1)
        }
    }

    Text
    {
        id: month
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            top: weekday.baseline
            topMargin: Theme.paddingMedium
        }
        color: timeText.color
        font
        {
            pixelSize: Theme.fontSizeExtraLarge * 1.1; family: Theme.fontFamily
        }

        text: Format.formatDate(time, Format.DateMediumWithoutYear)
    }
}
