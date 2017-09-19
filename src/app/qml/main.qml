// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import Communi 3.5
import Fluid.Controls 1.0 as FluidControls
import Qt.labs.settings 1.0

FluidControls.ApplicationWindow {
    id: mainWindow

    minimumWidth: 1024
    minimumHeight: 800
    visible: true

    Irc {
        id: irc
    }

    IrcCommand {
        id: ircCommand
    }

    Settings {
        id: identitySettings

        category: "Identity"

        property string nickName
        property string realName
        property string userName
    }

    Settings {
        id: serverSettings

        category: "Server"

        property string host
        property int port
        property bool secure
        property string saslMechanism
        property string password
        property bool identify
        property string identityPassword
        property var channels: []
    }

    IrcBufferModel {
        id: ircBufferModel

        sortMethod: Irc.SortByTitle
        connection: IrcConnection {
            id: connection

            host: serverSettings.host
            port: serverSettings.port
            secure: serverSettings.secure
            saslMechanism: serverSettings.saslMechanism
            nickName: identitySettings.nickName
            realName: identitySettings.realName
            userName: identitySettings.userName
            password: serverSettings.password

            onConnected: {
                // Identify the account otherwise join channels immediately
                if (serverSettings.identify && serverSettings.identityPassword)
                    connection.sendCommand(ircCommand.createMessage("NickServ", "IDENTIFY " + serverSettings.identityPassword));
                else
                    joinChannels();
            }
            onNoticeMessageReceived: {
                // Join channels once identified
                if (serverSettings.identify && serverSettings.identityPassword) {
                    if (message.target === connection.nickName && message.private && message.content.includes("You are now identified"))
                        joinChannels();
                }
            }
            onErrorMessageReceived: {
                toast.open(message.error);
            }
        }

        onMessageIgnored: {
            ircServerBuffer.receiveMessage(message);
        }

        function quit() {
            ircBufferModel.clear();
            connection.quit(qsTr("Quitting"));
            connection.close();
        }
    }

    IrcBuffer {
        id: ircServerBuffer

        sticky: true
        persistent: true
        name: connection.displayName

        Component.onCompleted: {
            ircBufferModel.add(ircServerBuffer);
        }
    }

    function joinChannels() {
        for (var channel in serverSettings.channels) {
            joinTimer.channel = channel.name;
            joinTimer.password = channel.password;
            joinTimer.start();
        }
    }

    Timer {
        id: joinTimer

        property string channel
        property string password

        interval: 1000
        onTriggered: connection.sendCommand(ircCommand.createJoin(channel, password))



        //connection.sendCommand(ircCommand.createJoin("#anbox"));
        //connection.sendCommand(ircCommand.createJoin("#calamares"));
        //connection.sendCommand(ircCommand.createJoin("#communi"));
        //connection.sendCommand(ircCommand.createJoin("#flatpak"));
        //connection.sendCommand(ircCommand.createJoin("#halium"));
        //connection.sendCommand(ircCommand.createJoin("#halium-dev"));
        //            connection.sendCommand(ircCommand.createJoin("#kaosx"));
        //            connection.sendCommand(ircCommand.createJoin("#libhybris"));
        //connection.sendCommand(ircCommand.createJoin("#liri"));
        //            connection.sendCommand(ircCommand.createJoin("#literm"));
        //            connection.sendCommand(ircCommand.createJoin("#qbs"));
        //            connection.sendCommand(ircCommand.createJoin("#qt"));
        //            connection.sendCommand(ircCommand.createJoin("#qt-creator"));
        //            connection.sendCommand(ircCommand.createJoin("#qt-labs"));
        //            connection.sendCommand(ircCommand.createJoin("#qt-quick"));
        //            connection.sendCommand(ircCommand.createJoin("#qt-lighthouse"));
        //            connection.sendCommand(ircCommand.createJoin("#archlinux-it"));
        //            connection.sendCommand(ircCommand.createJoin("#qtgstreamer"));
        //            connection.sendCommand(ircCommand.createJoin("#sddm"));
        //            connection.sendCommand(ircCommand.createJoin("#unrealengine"));
        //            connection.sendCommand(ircCommand.createJoin("#wayland"));
        //            connection.sendCommand(ircCommand.createJoin("#systemd"));
        //            connection.sendCommand(ircCommand.createJoin("#openmandriva-cooker"));
        //            connection.sendCommand(ircCommand.createJoin("#ostree"));
        //            connection.sendCommand(ircCommand.createJoin("#fedora-devel"));
        //            connection.sendCommand(ircCommand.createJoin("#fedora-kde"));
    }

    Component {
        id: placeholderComponent

        PlaceholderPage {}
    }

    Component {
        id: chatComponent

        ChatPage {
            bufferModel: ircBufferModel
            serverBuffer: ircServerBuffer

            Component.onCompleted: {
                currentBuffer = ircServerBuffer;
                connection.open();
            }
        }
    }

    initialPage: serverSettings.host ? chatComponent : placeholderComponent

    FluidControls.InfoBar {
        id: toast
    }

    Component.onDestruction: {
        ircBufferModel.quit();
    }
}
