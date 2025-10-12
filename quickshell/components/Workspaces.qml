import QtQuick
import Quickshell.I3
import QtQuick.Controls

Rectangle {
    anchors.verticalCenter: parent.verticalCenter
    width: spaceContainer.width + 8
    height: spaceContainer.height + 8
    color: bg

    Row {
        id: spaceContainer
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        property var offsets: [
            {
                w: 48,
                chip: {
                    w: 4,
                    h: 4,
                    x: 4,
                    y: 32
                }
            },
            {
                w: 36,
                chip: {
                    w: 8,
                    h: 4,
                    x: 8,
                    y: 0
                }
            },
            {
                w: 44,
                chip: {
                    w: 8,
                    h: 4,
                    x: 4,
                    y: 32
                }
            },
            {
                w: 34,
                chip: {
                    w: 4,
                    h: 4,
                    x: 30,
                    y: 32
                }
            },
            {
                w: 40,
                chip: {
                    w: 8,
                    h: 4,
                    x: 0,
                    y: 0
                }
            },
        ]

        Repeater {
            model: I3.workspaces.values

            Button {
                id: space
                property var offset: spaceContainer.offsets[index % 5]
                width: offset.w ?? 32
                height: 36

                background: Rectangle {
                    color: modelData.active ? health : grey
                    Rectangle {
                        width: offset.chip.w
                        height: offset.chip.h
                        color: bg

                        x: offset.chip.x
                        y: offset.chip.y
                    }
                }

                onClicked: () => modelData.activate()

                contentItem: StyledText {
                    id: text
                    text: modelData.name
                    color: bg
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
