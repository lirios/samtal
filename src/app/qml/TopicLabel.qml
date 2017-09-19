// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.4
import QtQuick.Controls 2.2
import Fluid.Controls 1.0 as FluidControls
import Communi 3.5

FluidControls.TitleLabel {
    property IrcChannel channel

    IrcTextFormat {
        id: textFormat
    }

    text: channel && channel.topic ? textFormat.toHtml(channel.topic) : "-"
    wrapMode: Text.Wrap

    onLinkActivated: {
        Qt.openUrlExternally(link);
    }

    FluidControls.ThinDivider {
        y: parent.paintedHeight - height
        width: parent.parent.width
    }
}
