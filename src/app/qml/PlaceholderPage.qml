// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Fluid.Controls 1.0 as FluidControls

FluidControls.Page {
    actions: [
        FluidControls.Action {
            iconName: "content/add"
            toolTip: qsTr("Add network")
            onTriggered: addNetworkDialog.open()
        }
    ]

    Dialog {
        id: addNetworkDialog

        title: qsTr("Add network")
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 500
        height: 350
        modal: true
        focus: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            serverSettings.host = hostField.text;
            serverSettings.port = portSpinBox.value;
            serverSettings.password = passwordField.text;
            identitySettings.nickName = nickField.text;
            identitySettings.realName = realNameField.text;
            identitySettings.userName = userNameField.text || nickField.text;
            mainWindow.pageStack.push(chatComponent);
            connection.open();
        }

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                TextField {
                    id: hostField
                    placeholderText: qsTr("Server Address")
                    focus: true

                    Layout.fillWidth: true
                }

                SpinBox {
                    id: portSpinBox
                    from: 256
                    to: 65536
                    value: 6667
                }

                Layout.fillWidth: true
            }

            TextField {
                id: passwordField
                placeholderText: qsTr("Password")
                echoMode: TextField.Password

                Layout.fillWidth: true
            }

            TextField {
                id: nickField
                placeholderText: qsTr("Nick Name")

                Layout.fillWidth: true
            }

            TextField {
                id: userNameField
                placeholderText: qsTr("User Name")

                Layout.fillWidth: true
            }

            TextField {
                id: realNameField
                placeholderText: qsTr("Real Name")

                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    FluidControls.Placeholder {
        anchors.fill: parent

        iconName: "communication/chat_bubble_outline"
        text: qsTr("Liri IRC")
        subText: "Join a room using the + button."
    }
}
