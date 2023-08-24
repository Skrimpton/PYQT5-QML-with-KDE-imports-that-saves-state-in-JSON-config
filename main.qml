import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PC2
import org.kde.plasma.components 3.0 as PC3
import "functions.js" as F
import org.kde.draganddrop 2.0 as DragDrop
// import QtGraphicalEffects 1.15

ApplicationWindow {
    id:fullRoot
    // title: "Test APP — PYQT5 + QML + PlasmaCore++"

    signal responseXml(string response)
    property double xWidth
    property double xHeight
    property string currTime: "00:00:00"
    property string configPath:""
    property var config
    property bool pinned
    property QtObject backend
    minimumHeight:200
    minimumWidth:170
    // onResponseXml: {
    //     print(JSON.parse(response).window_sizes.xHeight)
    // }
    visible: true

    width: xWidth
    height: xHeight
    x: screen.desktopAvailableWidth / 2 - (width/2) /*- width - 12*/
    y: screen.desktopAvailableHeight / 2 - (height/2)
    flags: (
        pinned ? (
            Qt.FramelessWindowHint
            | Qt.WA_TranslucentBackground
            | Qt.WindowStaysOnTopHint
        ) : (
            Qt.FramelessWindowHint
            | Qt.WA_TranslucentBackground
        )

    )
    color:"transparent"

    // ColorSelector {  // works, but creates a *very* simple (presumably fallback) non-native colordialog
    //     id:colorBox
    // }

    background:Rectangle {
        id:_bg
        anchors.fill: parent
        color: {
            var r = PlasmaCore.Theme.viewBackgroundColor.r
            var g = PlasmaCore.Theme.viewBackgroundColor.g
            var b = PlasmaCore.Theme.viewBackgroundColor.b
            var a = 0.4
            Qt.rgba(r,g,b,a)
        }
    }


    ButtonClose {
        id:_closeButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins:1
        width:PlasmaCore.Units.iconSizes.smallMedium
        height:width
        onClicked:{
            F.saveAndClose()
        }
    }

    ButtonPin {
        id:_pinButton
        anchors.top: parent.top
        anchors.right: _closeButton.left
        anchors.margins:1
        // anchors.left: parent.left
        // anchors.margins:0
        width:PlasmaCore.Units.iconSizes.smallMedium
        height:width
    }

    ButtonLabel {
        id:_labelButton
        anchors.top:_closeButton.bottom
        height:PlasmaCore.Units.iconSizes.smallMedium + 10
        width:parent.width
        text:fullRoot.configPath
        onClicked:{

            // Rc.readConfig(configPath)

            if (fullRoot.background.color === PlasmaCore.Theme.viewBackgroundColor) {
                // fullRoot.background.color = "transparent"

                var r = PlasmaCore.Theme.viewBackgroundColor.r
                var g = PlasmaCore.Theme.viewBackgroundColor.g
                var b = PlasmaCore.Theme.viewBackgroundColor.b
                var a = 0.4

                fullRoot.background.color = Qt.rgba(r,g,b,a)

            }
            else {
                fullRoot.background.color = PlasmaCore.Theme.viewBackgroundColor
            }
        }
    }

    ListModel {
        id:_mainModel
    }

    ListView{
        id:_mainList
        model:_mainModel
        anchors {
            left:parent.left
            right:parent.right
            top:_labelButton.bottom
            bottom:_clockLabel.top
        }
        clip:true
        delegate:FlickableField {

            id:flickDel
            // height:30
            fieldText:title
            onFieldTextChanged: {
                _mainModel.get(index).title = fieldText
            }
        }
    }

    PC3.Label {
        id:_clockLabel
        height:implicitHeight
        // width:parent.width
        anchors {
            bottom: parent.bottom
            bottomMargin: 12
            left: parent.left
            right: parent.right
        }
        text: currTime  // used to be; text: "16:38:33"
        // text: Qt.Window
        font.pointSize: 30
        horizontalAlignment:Text.AlignHCenter
        verticalAlignment:Text.AlignVCenter
        color: "white"
    }

    Connections {
        target: backend

        function onUpdated(msg) {
            currTime = msg;
        }
        function onSaveConfigIrr() {
            F.saveAndClose()
        }
        function onUpdateList() {
            for (var i = 0 ; i < fullRoot.config.url_list.length ; i++) {
                _mainModel.append(fullRoot.config.url_list[i])

            }
            config.url_list = ""
        }
    }
    DragDrop.DropArea {
        anchors {
            fill:parent
        }
        onDrop: {
            var item = {
                "title":event.mimeData.text,
                "url":event.mimeData.text
            }
            _mainModel.append(item)
            print(event.mimeData.text)
        }
    }
}
