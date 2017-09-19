// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.1
import Fluid.Core 1.0 as FluidCore

Dialog {
    id: joinDialog

    title: qsTr("Join")
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 300
    height: 250
    modal: true
    focus: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    onAccepted: {
        serverSettings.channels.push({name: channelField.text, password: passwordField.text});
        connection.sendCommand(ircCommand.createJoin(channelField.text, passwordField.text));
        channelField.text = "";
        passwordField.text = "";
        channelField.forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent

        TextField {
            id: channelField
            placeholderText: qsTr("Enter channel")
            focus: true
            onAccepted: joinDialog.accept()

            Layout.fillWidth: true
        }

        TextField {
            id: passwordField
            placeholderText: qsTr("Password")
            echoMode: FluidCore.Device.isMobile ? TextField.PasswordEchoOnEdit : TextField.Password
            onAccepted: joinDialog.accept()

            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
