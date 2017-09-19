# SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# SPDX-License-Identifier: CC0-1.0

liri_add_executable("LiriSamtal"
    OUTPUT_NAME
        "liri-samtal"
    SOURCES
        main.cpp
    RESOURCES
        app.qrc
    DEFINES
        QT_NO_CAST_FROM_ASCII
        QT_NO_FOREACH
	VERSION="${PROJECT_VERSION}"
    APPDATA
        "${CMAKE_SOURCE_DIR}/data/appdata/io.liri.Samtal.appdata.xml"
    DESKTOP
        "${CMAKE_SOURCE_DIR}/data/io.liri.Samtal.desktop"
    LIBRARIES
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::Qml
        Qt5::Quick
        Qt5::QuickControls2
    GUI
)
