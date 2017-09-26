/****************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Petri M. Gerdt <petri.gerdt@jollamobile.com>
**
****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Lipstick 1.0
import org.nemomobile.time 1.0
import org.nemomobile.lipstick 0.1

Item
{
    id: clock

    property alias time: timeText.time
    property alias color: month.color
    property alias updatesEnabled: timeText.updatesEnabled

    width: month.width
    height: month.height

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
            horizontalCenter: parent.horizontalCenter
        }
        color: Theme.primaryColor
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
