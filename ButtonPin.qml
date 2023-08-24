import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PC3
Item {
    id:pinButton
    property bool pinned:fullRoot.pinned

    PlasmaCore.IconItem {
        implicitWidth:PlasmaCore.Units.iconSizes.small
        implicitHeight:implicitWidth
        anchors.centerIn:parent
        source:pinButton.pinned ? "window-pin" : "window-unpin"
    }

    MouseArea {
        anchors.fill:parent
        onClicked:{
            fullRoot.pinned = !pinButton.pinned
            /*
            if(pinButton.pinned)
                fullRoot.flags = fullRoot.flags | Qt.WindowStaysOnTopHint
            else
                fullRoot.flags = fullRoot.flags & ~Qt.WindowStaysOnTopHint
            */
        }
    }
}
