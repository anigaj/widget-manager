import QtQuick 2.2
import Sailfish.Silica 1.0
import "file:///usr/share/lipstick-jolla-home-qt5/lockscreen"

Item
{
    height: clock.height 
    width: clock.width

    Clock {
        id: clock

        property bool cannotCenter: Screen.sizeCategory <= Screen.Medium && lockScreenPage.isPortrait

        followPeekPosition: true
        property real peekOffset: followPeekPosition
                        ? lockScreen.progress * lockScreen.peekFilter.threshold * 0.25
                        : 0
        property real animationOffset
        readonly property real offset: Math.max(peekOffset, animationOffset)

        property string positionState: {
            if (lockScreen.lowPowerMode) {
                return "fixed-center"
            } else if (!lockScreen.locked && !visible) {
                return "fixed-raised"
            } else if (!lockItem.allowAnimations) {
                return lockScreen.lockScreenAnimated ? "raised" : "fixed-center"
            } else if (lockScreen.panning) {
                return "panning"
            } else if (!lockScreen.locked) {
                    return "raised"
            } else {
                    return "center"
            }
        }

        onPositionStateChanged: {
            if (positionState == "fixed-raised") {
                offsetAnimation.stop()
                animationOffset = lockScreen.peekFilter.threshold * 0.5
                opacityAnimation.stop()
                opacity = 0
            } else if (positionState == "fixed-center") {
                offsetAnimation.stop()
                animationOffset = 0
                opacityAnimation.stop()
                opacity = 1
            } else if (positionState == "raised") {
                offsetAnimation.from = offset
                offsetAnimation.to = lockScreen.peekFilter.threshold * 0.5
                offsetAnimation.duration = 400
                offsetAnimation.restart()
                opacityAnimation.duration = 400
                opacityAnimation.to = 0
                opacityAnimation.restart()
            } else {
                offsetAnimation.from = offset
                offsetAnimation.to = 0
                offsetAnimation.duration = 500
                offsetAnimation.restart()
                opacityAnimation.duration = 500
                opacityAnimation.to = 1
                opacityAnimation.restart()
            }
        }

        FadeAnimation
        {
            id: opacityAnimation
            target: clock
        }

        NumberAnimation on animationOffset
        {
            id: offsetAnimation
            running: false
            easing.type: Easing.InOutQuad
        }

        anchors
        {
             horizontalCenter: parent.horizontalCenter
             top: parent.top
             topMargin: Theme.paddingLarge - offset
             verticalCenterOffset: !cannotCenter ? -offset : 0
        }

        color: lockScreen.textColor
        updatesEnabled: visible

    }

}