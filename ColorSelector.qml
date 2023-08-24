// Version 6
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick 2.4
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Dialogs 1.2
// import QtQuick.Window 2.2
// import QtGraphicalEffects 1.12 as QtGraphicalEffects
// import org.kde.kirigami 2.2 as Kirigami
// import org.kde.kirigami 2.12 as Kirigami

Loader {
	id: control_loader
	signal clicked
	property bool showAlphaChannel: true
	property string title: ''
	property string configKey: ''
	property string defaultColor: ''
	property string value: {
		if (configKey) {
			return plasmoid.configuration[configKey]
		} else {
			return "#000"
		}
	}


	readonly property color valueColor: {
			return fullRoot.background.color
	}

	onValueChanged: {
		if (configKey) {
			if (value == defaultColorValue) {
				plasmoid.configuration[configKey] = ""
			} else {
				plasmoid.configuration[configKey] = value
			}
		}
	}

	onClicked: control_loader.active = !control_loader.active
	active: false
	property string loadedTitle : title
	Connections {
		target:control_loader.item
		function onDeactivate() {
			control_loader.active = false
		}
	}
	sourceComponent:Component {
		Item {
			signal deactivate
			Timer {
				id:delayUnload
				interval:180
				onTriggered: {
					if (!dialog.visible) {
						deactivate()
					}
				}
			}

			ColorDialog {
				id: dialog
				visible: false
				modality: Qt.WindowModal
				title:loadedTitle
				showAlphaChannel: control_loader.showAlphaChannel
				// color: control_loader.valueColor
				onAccepted: {
					// print("ColorSelector accepted color:",color)
					print(color)
					control_loader.value = color
					fullRoot.background.color = color
				}
				onVisibleChanged: {
					delayUnload.restart()
				}

				// showAlphaChannel must be set before opening the dialog.
				// If we create the dialog with visible=true, the showAlphaChannelbinding
				// will not be set before it opens.
				Component.onCompleted: {
					visible = true
					var r = fullRoot.background.color.r
					var g = fullRoot.background.color.g
					var b = fullRoot.background.color.b
					var a = fullRoot.background.color.a
					color = Qt.rgba(r,g,b,a)
					currentColor = Qt.rgba(r,g,b,a)
				}

			}
		}
	}
}

