// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import QtQuick.Controls 2.2
import Communi 3.5

TextField {
    id: textField

    property alias buffer: completer.buffer

    signal messageSent(IrcMessage message)

    focus: true
    placeholderText: qsTr("Type a message or a command here")

    Keys.onTabPressed: completer.complete(text, cursorPosition)

    onAccepted: {
        var command = parser.parse(text);
        if (command) {
            buffer.connection.sendCommand(command);
            if (command.type === IrcCommand.Message
                    || command.type === IrcCommand.CtcpAction
                    || command.type === IrcCommand.Notice) {
                var message = command.toMessage(buffer.connection.nickName, buffer.connection);
                textField.messageSent(message);
            }
            textField.text = "";
        }
    }

    IrcCompleter {
        id: completer

        parser: IrcCommandParser {
            id: parser

            tolerant: true
            triggers: ["/"]
            channels: buffer ? buffer.model.channels : []
            target: buffer ? buffer.title : ""

            Component.onCompleted: {
                parser.addCommand(IrcCommand.Join, "JOIN <#channel> (<key>)");
                parser.addCommand(IrcCommand.CtcpAction, "ME [target] <message...>");
                parser.addCommand(IrcCommand.Nick, "NICK <nick>");
                parser.addCommand(IrcCommand.Part, "PART (<#channel>) (<message...>)");
            }
        }

        onCompleted: {
            textField.text = text;
            textField.cursorPosition = cursor;
        }
    }
}
