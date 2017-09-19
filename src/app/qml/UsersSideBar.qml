// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Fluid.Controls 1.0 as FluidControls
import Communi 3.5

Pane {
    id: sideBar

    property IrcChannel channel

    signal queried(IrcUser user)

    implicitWidth: 200
    padding: 0

    Material.elevation: 1

    ListView {
        id: listView

        anchors.fill: parent

        model: IrcUserModel {
            id: userModel

            sortMethod: Irc.SortByTitle
            channel: sideBar.channel

            onChannelChanged: {
                listView.currentIndex = -1;
            }
        }
        delegate: FluidControls.ListItem {
            iconName: {
                switch (model.mode) {
                case "o":
                    return "action/supervisor_account";
                case "v":
                    return "action/verified_user";
                default:
                    break;
                }

                return "action/account_box";
            }
            text: model.title
            opacity: model.away ? 0.5 : 1.0
            highlighted: ListView.isCurrentItem

            onClicked: {
                listView.currentIndex = index;
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
