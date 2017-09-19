// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import QtQuick.Controls 2.2
import Fluid.Controls 1.0 as FluidControls
import Communi 3.5

Item {
    property IrcBuffer buffer

    Connections {
        target: buffer
        onMessageReceived: {
            var line = formatter.formatMessage(message);
            if (line)
                textArea.append(line);
        }
    }

    MessageFormatter {
        id: formatter
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

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

        TextArea {
            id: textArea

            readOnly: true
            textFormat: Qt.RichText
            selectByKeyboard: true
            selectByMouse: true
            background: Item {}

            onCursorRectangleChanged: scrollView.ensureVisible(cursorRectangle)
            onLinkActivated: Qt.openUrlExternally(link)

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: textArea.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
        }
    }
}
