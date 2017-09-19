// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.0
import Fluid.Controls 1.0 as FluidControls

FluidControls.Page {
    actions: [
        FluidControls.Action {
            iconName: "content/add"
            toolTip: qsTr("Join a new channel")
            enabled: connection.connected
            onTriggered: joinDialog.open()
        }
    ]

    JoinDialog {
        id: joinDialog
    }
}
