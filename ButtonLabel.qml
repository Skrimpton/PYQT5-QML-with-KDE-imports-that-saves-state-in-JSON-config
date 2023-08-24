import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3
Rectangle {
    id:control
    color:PlasmaCore.Theme.viewBackgroundColor
    border.color:PlasmaCore.Theme.viewHoverColor
    border.width:1
    radius:height
    property alias labelWidth: buttonLabel.implicitWidth
    property alias text: buttonLabel.text
    signal clicked

    PC3.Label {
        id:buttonLabel
        text:"QML to Python"
        elide:Text.ElideRight
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.margins:4
        // width:parent.width
        height:implicitHeight
        horizontalAlignment:Text.AlignHCenter
        anchors.verticalCenter:parent.verticalCenter

    }
    MouseArea {
        anchors.fill:parent
        acceptedButtons:Qt.LeftButton|Qt.RightButton
        // onClicked:print("clicked button")
        onClicked:{
            control.clicked()
        }
    }
}
