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

    property alias bufferModel: listView.model
    property IrcBuffer currentBuffer

    signal selected(int index)
    signal closed(IrcBuffer buffer)

    width: 256
    padding: 0

    Material.elevation: 1

    ListView {
        id: listView

        anchors.fill: parent

        /*
        section.property: "category"
        section.delegate: FluidControls.Subheader {
            text: model.section

            FluidControls.ThinDivider {
                visible: parent.y > 0
            }
        }
        */
        delegate: FluidControls.ListItem {
            iconName: "communication/chat"
            text: model.title || model.name || model.display || qsTr("Unknown")
            highlighted: model.buffer === currentBuffer

            onClicked: {
                currentBuffer = model.buffer;
                sideBar.selected(index);
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
