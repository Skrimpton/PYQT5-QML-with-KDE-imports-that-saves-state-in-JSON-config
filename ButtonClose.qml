import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3

Item {
    id:control
    signal clicked
    PlasmaCore.IconItem {
        implicitWidth:PlasmaCore.Units.iconSizes.small
        implicitHeight:implicitWidth
        anchors.centerIn:parent
        source:"dialog-close"
    }
    MouseArea {
        anchors.fill:parent
        onClicked:{
            control.clicked()
        }
    }
}
