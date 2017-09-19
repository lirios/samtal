// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import QtQuick.Layouts 1.2
import Fluid.Controls 1.0 as FluidControls
import Communi 3.5

BasePage {
    id: chatPage

    property IrcBuffer serverBuffer
    property alias bufferModel: sideBar.bufferModel
    property alias currentBuffer: sideBar.currentBuffer
    property IrcChannel currentChannel: currentBuffer ? currentBuffer.toChannel() : null

    Connections {
        target: bufferModel

        onAdded: {
            currentBuffer = buffer;
        }
        onAboutToBeRemoved: {
            var index = bufferModel.indexOf(buffer);
            currentBuffer = bufferModel.get(index + 1) || bufferModel.get(Math.max(0, index - 1));
        }
    }

    BufferSideBar {
        id: sideBar

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        onClosed: {
            if (buffer == serverBuffer) {
                bufferModel.quit();
            } else {
                if (buffer.channel)
                    buffer.part(qsTr("Good bye!"));
                bufferModel.remove(buffer);
            }
        }
    }

    Item {
        id: stack

        anchors.left: sideBar.right
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: FluidControls.Units.smallSpacing

        Repeater {
            model: bufferModel
            delegate: ColumnLayout {
                anchors.fill: parent
                visible: model.buffer === currentBuffer

                onVisibleChanged: {
                    if (visible)
                        textEntry.forceActiveFocus();
                }

                TopicLabel {
                    channel: currentChannel
                    visible: channel != null

                    Layout.fillWidth: true
                }

                RowLayout {
                    ChatTextBrowser {
                        id: textBrowser

                        buffer: model.buffer

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    UsersSideBar {
                        id: usersSideBar

                        channel: currentChannel
                        visible: channel != null

                        onQueried: {
                            currentBuffer = currentBuffer.model.add(user.name);
                        }

                        Layout.preferredWidth: 200
                        Layout.fillHeight: true
                    }

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                TextEntry {
                    id: textEntry

                    buffer: currentBuffer
                    enabled: currentBuffer != null

                    onMessageSent: {
                        currentBuffer.receiveMessage(message);
                    }

                    Layout.fillWidth: true
                }
            }
        }
    }
}
