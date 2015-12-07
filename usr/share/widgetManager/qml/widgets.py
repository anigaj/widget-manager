#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#  Copyright (C) 2015 Jolla Ltd.
#  Contact: Jussi Pakkanen <jussi.pakkanen@jolla.com>
#  All rights reserved.
#
#  You may use this file under the terms of BSD license as follows:
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the Jolla Ltd nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This file demonstrates how to write a class that downloads data from the
# net, does heavy processing or some other operation that takes a long time.
# To keep the UI responsive we do the operations in a separate thread and
# send status updates via signals.

import pyotherside

import os, json, shutil

widgets = []
visibleWidgets = []
screenWidth = 0 
screenHeight = 0
isPortrait = 0
width = 0

def getWidgets():

    path_to_json = '/usr/share/widgetManager/widgets/'
    json_files = [pos_json for pos_json in os.listdir(path_to_json) if pos_json.endswith('.json')]

    widgets.clear()
    a_dict = {'isVisible':0} 
    for js in json_files:
        with open(os.path.join(path_to_json, js)) as json_file:
            data = json.load(json_file)
            data.update(a_dict) 
            widgets.append(data)

    return widgets
  
def initWidgets(sWidth, sHeight, isPort):
    visibleWidgets.clear()
    global screenWidth 
    global screenHeight
    global isPortrait
    global width

    screenWidth = sWidth
    screenHeight = sHeight
    isPortrait = isPort
    if(isPort):
        width = sWidth
    else:
        width = sHeight

def cancelLayout():
    shutil.copyfile("widgetManager/PortraitWidgets.qml.old","widgetManager/PortraitWidgets.qml")
    shutil.copyfile("widgetManager/LandscapeWidgets.qml.old","widgetManager/LandscapeWidgets.qml")

def backupLayout():
    shutil.copyfile("widgetManager/PortraitWidgets.qml","widgetManager/PortraitWidgets.qml.old")
    shutil.copyfile("widgetManager/LandscapeWidgets.qml","widgetManager/LandscapeWidgets.qml.old")

def createQML():
    if(isPortrait):
        file = open("widgetManager/PortraitWidgets.qml","w")
    else:
        file = open("widgetManager/LandscapeWidgets.qml","w")

    visibleWidgetsx = sorted(visibleWidgets, key=lambda k: k['xy'])

    header = "import QtQuick 2.0\nimport Sailfish.Silica 1.0\n"
    body = "Item{\nanchors.fill: parent\n"
    topLine = True
    sameLine = False
    for index, visibleWidget in enumerate(visibleWidgetsx):
        header = header + "import \"file://" + visibleWidget['path'] + "\"\n"
        body = body + visibleWidget['main'] + "{\nid: " + visibleWidget['main'].lower() + "\nanchors{\ntop: "
        if(index > 0):
            if(visibleWidget['y'] >= ( visibleWidgetsx[index-1]['y'] +visibleWidgetsx[index-1]['h'])):
                topLine = False
                sameLine = False
            else:
                sameLine = True 
        if(topLine):
            body = body +  "parent.top\ntopMargin: " + str(visibleWidget['y']) +  "\n"
            if(sameLine):
                body = body + "right: "+visibleWidgetsx[index-1]['main'].lower() + ".left\nrightMargin: " +  str(visibleWidgetsx[index-1]['x'] -(visibleWidget['x'] + visibleWidget['w'])) +  "\n}\n"
            else:
                body = body + "right: parent.right\nrightMargin: " +  str(width  - (visibleWidget['x'] + visibleWidget['w'])) +  "\n}\n"
        else:
            body = body +visibleWidgetsx[index-1]['main'].lower() + ".bottom\ntopMargin: " + str(visibleWidget['y'] - (visibleWidgetsx[index-1]['y'] +visibleWidgetsx[index-1]['h'])) +  "\n"
            if(sameLine):
                body = body + "right: "+visibleWidgetsx[index-1]['main'].lower() + ".left\nrightMargin: " +  str(visibleWidgetsx[index-1]['x'] -(visibleWidget['x'] + visibleWidget['w'])) +  "\n}\n"
            else:
                body = body + "right: parent.right\nrightMargin: " +  str(width  - (visibleWidget['x'] + visibleWidget['w'])) +  "\n}\n"

        body = body + "}\n" 
    body = body + "}"
    file.write(header)
    file.write(body)

def appendWidget(visibleWidget):
    data = next(item for item in widgets if item["name"]==visibleWidget.name)
    hPixels = 100.0
    if(visibleWidget.height != "variable"):
        hPixels = float(visibleWidget.height)*screenHeight  

    wPixels = 100.0
    if(visibleWidget.width != "variable"):
        wPixels = float(visibleWidget.width)*screenWidth
    xy = width - (visibleWidget.x + wPixels) + visibleWidget.y 
    a_dict = {'x': visibleWidget.x , 'y': visibleWidget.y, 'h': hPixels, 'w':wPixels, 'xy': xy}
    data.update(a_dict) 
    visibleWidgets.append(data)
    