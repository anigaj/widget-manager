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

#Function that populate list of widgets from json files and appends isVisible
def getWidgets(isPort):
    path_to_json = '/usr/share/widgetManager/widgets/'
    json_files = [pos_json for pos_json in os.listdir(path_to_json) if pos_json.endswith('.json')]

    widgets.clear()
    if(isPort): 
        jsFile = open("/home/nemo/widgetManager/PortraitWidgetsPos.json")
    else:                        
        jsFile = open("/home/nemo/widgetManager/LandscapeWidgetsPos.json")
    currentWidgets = json.load(jsFile) 
    defaultData = {'x': 0 , 'y': 0, 'h': 0, 'w':0, 'hAnchor':'auto', 'hAnchorTo': 'top', 'hAnchorItem': 'lockscren', 'vAnchor': 'auto', 'vAnchorTo': 'right', 'vAnchorItem': 'lockscreen', 'isVisible':0 } 
    for js in json_files:
        with open(os.path.join(path_to_json, js)) as json_file:
            data = json.load(json_file)
            if not any(d['name'] == data['name'] for d in currentWidgets):
                a_dict = defaultData
            else:                                                                            
                a_dict = next(item for item in currentWidgets if item["name"]==data['name'])

            data.update(a_dict) 
            widgets.append(data)

    return widgets

#clear widget array and initialise heights and widths
def initWidgets(sWidth, sHeight, isPort):
    visibleWidgets.clear()
    global screenWidth 
    global screenHeight
    global isPortrait
    global width
    global height
    screenWidth = sWidth
    screenHeight = sHeight
    isPortrait = isPort
    if(isPort):
        width = sWidth
        height = sHeight
    else:
        width = sHeight
        height = sWidth

#Called when there is an error, reverts back to the back up files
def cancelLayout():
    shutil.copyfile("/home/nemo/widgetManager/PortraitWidgets.qml.old","/home/nemo/widgetManager/PortraitWidgets.qml")
    shutil.copyfile("/home/nemo/widgetManager/LandscapeWidgets.qml.old","/home/nemo/widgetManager/LandscapeWidgets.qml")

    shutil.copyfile("/home/nemo/widgetManager/PortraitWidgetsPos.json.old","/home/nemo/widgetManager/PortraitWidgetsPos.json")
    shutil.copyfile("/home/nemo/widgetManager/LandscapeWidgetsPos.json.old","/home/nemo/widgetManager/LandscapeWidgetsPos.json")

#Back up last good configuration
def backupLayout():
    shutil.copyfile("/home/nemo/widgetManager/PortraitWidgets.qml","/home/nemo/widgetManager/PortraitWidgets.qml.old")
    shutil.copyfile("/home/nemo/widgetManager/LandscapeWidgets.qml","/home/nemo/widgetManager/LandscapeWidgets.qml.old")

    shutil.copyfile("/home/nemo/widgetManager/PortraitWidgetsPos.json","/home/nemo/widgetManager/PortraitWidgetsPos.json.old")
    shutil.copyfile("/home/nemo/widgetManager/LandscapeWidgetsPos.json","/home/nemo/widgetManager/LandscapeWidgetsPos.json.old")

#Create the new qml file using x y positions
def createQMLxy():
    if(isPortrait):
        file = open("/home/nemo/widgetManager/PortraitWidgets.qml","w")
        jsFile = open("/home/nemo/widgetManager/PortraitWidgetsPos.json","w")
    else:
        file = open("/home/nemo/widgetManager/LandscapeWidgets.qml","w")
        jsFile = open("/home/nemo/widgetManager/LandscapeWidgetsPos.json","w")

#write the widget positions to json
    json.dump(visibleWidgets, jsFile)

# now write qml file
    header = "import QtQuick 2.0\nimport Sailfish.Silica 1.0\n"
    body = "Item{\nanchors.fill: parent\n"
    #Loop over widgets
    for index, visibleWidget in enumerate(visibleWidgets):                                                                        

        header = header + "import \"file://" + visibleWidget['path'] + "\"\n"
        body = body + visibleWidget['main'] + "{\nid: " + visibleWidget['main'].lower() + "\nx: " +str(round( visibleWidget['x'] ))+ "\ny: " + str(round( visibleWidget['y'] )) + "}\n"
 
    body = body + "}"
    file.write(header)
    file.write(body)

#Create the new qml file using anchors
def createQML():
    if(isPortrait):
        file = open("/home/nemo/widgetManager/PortraitWidgets.qml","w")
        jsFile = open("/home/nemo/widgetManager/PortraitWidgetsPos.json","w")
    else:
        file = open("/home/nemo/widgetManager/LandscapeWidgets.qml","w")
        jsFile = open("/home/nemo/widgetManager/LandscapeWidgetsPos.json","w")

#write the widget positions to json
    json.dump(visibleWidgets, jsFile)

# now write qml file

    # sort based on distance to center of widget from top right
    visibleWidgetsx = sorted(visibleWidgets, key=lambda k: k['xy'])

    header = "import QtQuick 2.0\nimport Sailfish.Silica 1.0\n"
    body = "Item{\nanchors.fill: parent\n"
    topLine = True
    sameLine = False

    #Loop over widgets
    for index, visibleWidget in enumerate(visibleWidgetsx):
        header = header + "import \"file://" + visibleWidget['path'] + "\"\n"
        body = body + visibleWidget['main'] + "{\nid: " + visibleWidget['main'].lower()
        if(index > 0):
            #Check if widget is on the same line as previous (current widget is placed above half previous)
            if(visibleWidget['y'] >= ( visibleWidgetsx[index-1]['y'] +0.5*visibleWidgetsx[index-1]['h'])):
                topLine = False
                sameLine = False
            else:
                # Check if we are on the next column of widgets (current widget is higher than the last)
                if((visibleWidget['y']) <  visibleWidgetsx[index-1]['y']):
                    topLine = True
                else:
                    sameLine = True 
        if(topLine and visibleWidget['hAnchor']=="auto"):
            body = body + "\nanchors{\ntop: parent.top\ntopMargin: " + str(visibleWidget['y']) +  "\n"
        elif(visibleWidget['hAnchor']=="auto"):
            body = body +"\nanchors{\ntop:" +visibleWidgetsx[index-1]['main'].lower() + ".bottom\ntopMargin: " + str(round(visibleWidget['y'] - (visibleWidgetsx[index-1]['y'] +visibleWidgetsx[index-1]['h']))) +  "\n"
        else:                                                                                                                                                                            
            body = body + getPositionInfoH(visibleWidget)+  "\n" 

        if(sameLine and visibleWidget['vAnchor']=="auto"):
            body = body + "right: "+visibleWidgetsx[index-1]['main'].lower() + ".left\nrightMargin: " +  str(round(visibleWidgetsx[index-1]['x'] -(visibleWidget['x'] + visibleWidget['w']))) +  "\n}\n"
        elif(visibleWidget['vAnchor']=="auto"):
            body = body + getHorizontalAnchor(visibleWidget['x'],visibleWidget['x']+visibleWidget['w']/2,visibleWidget['x']+visibleWidget['w']) +  "\n}\n" 
        else:
            body = body + getPositionInfoV(visibleWidget)+  "\n}\n" 

        body = body + "}\n" 
    body = body + "}"
    file.write(header)
    file.write(body)

# Add widget to visibleWidget array
#def appendWidget(vwName, vwHeight, vwWidth, vwX, vwY ):                                                                                                                                                                                                    
def appendWidget(vwx,vwy, visibleWidget):                                                                                                                                                                                                    
#need to bring in x and y directly as there seems to be a caching bug
    data = next(item for item in widgets if item["name"]==visibleWidget.name)

    hPixels = float(visibleWidget.height)
    wPixels = float(visibleWidget.width)

    # Calculate hypotenuse squared (distance from top right)
    xy = (width - (vwx + wPixels/2))*(width - (vwx + wPixels/2)) + (vwy+hPixels/2)*(vwy+hPixels/2) 
    a_dict = {'x': vwx , 'y': vwy, 'h': hPixels, 'w':wPixels, 'xy': xy, 'hAnchor': visibleWidget.hAnchor, 'hAnchorTo': visibleWidget.hAnchorTo, 'hAnchorItem': visibleWidget.hAnchorItem, 'vAnchor': visibleWidget.vAnchor, 'vAnchorTo': visibleWidget.vAnchorTo, 'vAnchorItem': visibleWidget.vAnchorItem, 'isVisible':1 }
    data.update(a_dict) 
    visibleWidgets.append(data)

#Determine whether we need to left, middle or right anchor nased on distance to each
def getHorizontalAnchor(left, middle, right):
    position = []

    a_dict = {'diff': abs(left), 'text':'left:parent.left\nleftMargin:' + str(round(left))}
    position.append(a_dict)
    
    a_dict = {'diff': abs(middle-width/2), 'text':'horizontalCenter:parent.horizontalCenter\nhorizontalCenterOffset:' + str(round(middle-width/2))}
    position.append(a_dict)

    a_dict = {'diff': abs(right - width), 'text':'right:parent.right\nrightMargin:'+str(round(width-right))}
    position.append(a_dict)

    sortedPos = sorted(position, key=lambda k: k['diff'])

    return sortedPos[0]['text']

#get horizontal anchor when not auto
def getPositionInfoH(visibleWidget):                                                                                                                                                                                                                                                                                                                            
    ancName = visibleWidget['hAnchorItem']
    if(ancName != "lockscreen"):
        anchorWidget = next(item for item in visibleWidgets if item['name']==ancName)

    widgetDict= {'top': visibleWidget['y'],'verticalCenter':(visibleWidget['y'] + visibleWidget['h']/2), 'bottom':  (visibleWidget['y'] + visibleWidget['h'])}
    anchorDict =[ ] 
    if(visibleWidget['hAnchorItem'] == "lockscreen"):
        anchorDict= {'top': 0,'verticalCenter':height/2, 'bottom':  height}
    else:                                                                                                                                                                                                                                                                                                                                                                    
        anchorDict= {'top': anchorWidget['y'],'verticalCenter':(anchorWidget['y'] + anchorWidget['h']/2), 'bottom':  (anchorWidget['y'] + anchorWidget['h'])}

    body = "\nanchors{\n" + visibleWidget['hAnchor'] + ":"
    if(visibleWidget['hAnchorItem'] == "lockscreen"):
        body = body + "parent." + visibleWidget['hAnchorTo'] 
    else:                                                                                                                                                                                                                                                                                                                                                                                            
        body = body + anchorWidget['main'].lower() + "." + visibleWidget['hAnchorTo']  

    if (visibleWidget['hAnchor'] == "verticalCenter"):                                                                                                                                                                                                                                                                                                                                                                                                
        body = body + "\nverticalCenterOffset: "+str(widgetDict[visibleWidget['hAnchor'] ] - anchorDict[visibleWidget['hAnchorTo'] ]) 
    elif (visibleWidget['hAnchor'] == "top"):                                                                                                                                                                                                                                                                                                                                                                                                
        body = body + "\n" +visibleWidget['hAnchor'] +"Margin: "+str(widgetDict[visibleWidget['hAnchor'] ] - anchorDict[visibleWidget['hAnchorTo'] ])  
    else:                                                                                                                                                                                                                                                                                                                                                                                                        
        body = body + "\n" +visibleWidget['hAnchor'] +"Margin: "+str(-widgetDict[visibleWidget['hAnchor'] ] + anchorDict[visibleWidget['hAnchorTo'] ])  
    return body

#get vertical anchor when not auto
def getPositionInfoV(visibleWidget):                                                                                                                                                                                                                                                                                                                            
    ancName = visibleWidget['vAnchorItem']
    if(ancName != "lockscreen"):
        anchorWidget = next(item for item in visibleWidgets if item["name"]==visibleWidget['vAnchorItem'])
    widgetDict= {'left': visibleWidget['x'],'horizontalCenter':(visibleWidget['x'] + visibleWidget['w']/2), 'right':  (visibleWidget['x'] + visibleWidget['w'])}
    anchorDict = [ ] 
    if(visibleWidget['vAnchorItem'] == "lockscreen"):
        anchorDict= {'left': 0,'horizontalCenter':width/2, 'right':  width}
    else:                                                                                                                                                                                                                                                                                                                                                                    
        anchorDict= {'left': anchorWidget['x'],'horizontalCenter':(anchorWidget['x'] + anchorWidget['w']/2), 'right':  (anchorWidget['x'] + anchorWidget['w'])}

    body =  visibleWidget['vAnchor'] + ":"
    if(visibleWidget['vAnchorItem'] == "lockscreen"):
        body = body + "parent." + visibleWidget['vAnchorTo'] 
    else:                                                                                                                                                                                                                                                                                                                                                                                            
        body = body + anchorWidget['main'].lower() + "." + visibleWidget['vAnchorTo']  

    if (visibleWidget['vAnchor'] == "horizontalCenter"):                                                                                                                                                                                                                                                                                                                                                                                                
        body = body + "\nhorizontalCenterOffset: "+str(widgetDict[visibleWidget['vAnchor'] ] - anchorDict[visibleWidget['vAnchorTo'] ] )
    elif (visibleWidget['vAnchor'] == "left"):                                                                                                                                                                                                                                                                                                                                                                                                        
        body = body + "\n" +visibleWidget['vAnchor'] +"Margin: "+str(widgetDict[visibleWidget['vAnchor'] ] - anchorDict[visibleWidget['vAnchorTo'] ]) 
    else:                                                                                                                                                                                                                                                                                                                                                                                                        
        body = body + "\n" +visibleWidget['vAnchor'] +"Margin: "+str(-widgetDict[visibleWidget['vAnchor'] ] + anchorDict[visibleWidget['vAnchorTo'] ])  
    return body
