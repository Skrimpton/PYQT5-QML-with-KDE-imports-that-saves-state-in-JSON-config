import QtQuick 2.15
// import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3


Rectangle {
    id:control
    width:parent.width
    color:{

        if (containsMouse && !_flickField.activeFocus) {
            var r = PlasmaCore.Theme.viewHoverColor.r
            var g = PlasmaCore.Theme.viewHoverColor.g
            var b = PlasmaCore.Theme.viewHoverColor.b
            var a = 0.5
            Qt.rgba(r,g,b,a)
        }
        else if (containsMouse && _flickField.activeFocus) {
            var r = PlasmaCore.Theme.viewFocusColor.r
            var g = PlasmaCore.Theme.viewFocusColor.g
            var b = PlasmaCore.Theme.viewFocusColor.b
            var a = 1
            Qt.rgba(r,g,b,a)
        }
        else if (!containsMouse && _flickField.activeFocus) {
            var r = PlasmaCore.Theme.viewFocusColor.r
            var g = PlasmaCore.Theme.viewFocusColor.g
            var b = PlasmaCore.Theme.viewFocusColor.b
            var a = 1
            Qt.rgba(r,g,b,a)
        }
        else {
            fullRoot.background.color


        }
    }

    height:_flickField.implicitHeight + (f_margin * 3)
    property alias fieldText : _flickField.text
    property alias containsMouse : _flickField_ma.containsMouse
    property double f_margin : PlasmaCore.Units.devicePixelRatio * 4

    function pasteIt() { // --- Paste without newlines
        _pasteBuffer.noNewline_paste = true
        _pasteBuffer.paste()
    }
    Flickable {
        id:_flickable
        anchors {
            fill:parent
            margins:f_margin / 2
        }
        clip:true
        contentWidth:(_flickField.implicitWidth + _flickField.cursorRectangle.width)
        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }
        boundsBehavior:Flickable.StopAtBounds
        boundsMovement:Flickable.StopAtBounds
        TextEdit {
            id:_flickField
            property string placeholderText : "URL-Field"
            onFontChanged: {
                control.minimumHeight = (_flickField.font.pixelSize + 20)
                control.maximumHeight = (_flickField.font.pixelSize + 20)
                control.height = (_flickField.font.pixelSize + 20)
            }
            wrapMode:"NoWrap"
            font:_placeholderText.font
            color:PlasmaCore.Theme.textColor
            selectByMouse:true
            height:_flickable.height
            verticalAlignment:Text.AlignVCenter
            width:Math.max(_flickable.width,implicitWidth)
            onCursorRectangleChanged: _flickable.ensureVisible(cursorRectangle)

            PC3.Label {
                id:_placeholderText
                color:PlasmaCore.Theme.disabledTextColor
                visible:(_flickField.text === "")
                height:(_flickField.text === "") ? parent.height : 0
                width:parent.width
                horizontalAlignment:Text.AlignHCenter
                text:parent.placeholderText
                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        if (_flickField.activeFocus === false) {
                            _flickField.forceActiveFocus()
                        }
                    }
                }
            }


            TextEdit {
                id:_pasteBuffer
                visible:false
                height:0
                width:0
                property alias parentField : _flickField
                property bool noNewline_paste: false
                property bool helpText_paste: false
                onTextChanged: {
                    if (text.length > 0) {
                        if (noNewline_paste) {
                            if (text.includes("\n")) {
                                // // print("removed newline")
                                var noNewline = text.replace(/\n/g,"")
                                text = noNewline
                            }
                            _pasteBuffer.noNewline_paste = false

                        }

                        if (parentField.selectedText.length > 0) {
                            parentField.remove(parentField.selectionStart,parentField.selectionEnd)
                            parentField.insert(parentField.cursorPosition,text)
                        }
                        else {
                            parentField.insert(parentField.cursorPosition,text)
                        }

                        _pasteBuffer.text = ""
                    }
                }
            }
            Keys.onPressed: {
                if ((event.key == Qt.Key_V) && (event.modifiers & Qt.ControlModifier)) {
                    pasteIt()
                    // // print("PASTE")
                    event.accepted = true
                }
            }
            Keys.onTabPressed:{
                event.accepted = true
            }
            Keys.onReturnPressed:{
                if (text !== "") {

                }
            }
            Keys.onEnterPressed:{
                if (text !== "") {

                }
            }

            MouseArea {
                id:_flickField_ma
                acceptedButtons:Qt.RightButton
                anchors.fill:parent
                hoverEnabled:true
                onClicked: {

                    print("rightClicked FlickableField")
                    // _rightClickMenu.visualParent=_flickField
                    // _rightClickMenu.open(mouse.x,mouse.y)
                }
            }
        }
    }
}
