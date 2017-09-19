// SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QQuickStyle::setStyle(QStringLiteral("Material"));

    QGuiApplication app(argc, argv);
    app.setApplicationDisplayName(QStringLiteral("Samtal"));
    app.setApplicationName(QStringLiteral("Liri Samtal"));
    app.setApplicationVersion(QStringLiteral(VERSION));
    app.setOrganizationName(QStringLiteral("Liri"));
    app.setOrganizationDomain(QStringLiteral("liri.io"));
    app.setDesktopFileName(QStringLiteral("io.liri.Samtal.desktop"));
    app.setQuitOnLastWindowClosed(true);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
