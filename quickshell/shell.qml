import QtQuick
import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import Quickshell.I3 // for Process
import "components"

// todo
// remove badly named IDs
// remove magic numbers

Scope {
    id: root

    property var fg: "#ffffff"
    property var ufg: Qt.rgba(1, 1, 1, 0.8)
    property var bg: Qt.rgba(0, 0, 0, 1)
    property var tbg: Qt.rgba(0, 0, 0, 0.75)
    property var grey: "#525355"
    property var health: "#46f29b" //"#ffffff"

    PanelWindow {
        height: 52
        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
        }

        // Left Items
        Item {
            height: 44
            anchors.bottom: parent.bottom

            Row {
                leftPadding: 8

                // Workspaces {}
                Item {
                    width: workspaceContainer.width + 12
                    height: workspaceContainer.height + 16

                    Decoration {
                        end: false
                    }
                    Decoration {
                        end: true
                    }

                    Rectangle {
                        width: workspaceContainer.width + 8
                        height: workspaceContainer.height + 8
                        anchors.centerIn: parent

                        color: tbg
                        Row {
                            id: workspaceContainer
                            anchors.centerIn: parent
                            spacing: 4
                            Repeater {
                                model: I3.workspaces.values
                                Rectangle {
                                    width: 28
                                    height: 28
                                    color: modelData.active ? health : grey
                                }
                            }
                        }
                    }
                }
            }
        }

        // Center Items
        Item {
            height: 44
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            Row {
                id: middleRow
                anchors.horizontalCenter: parent.horizontalCenter
                StyledText {
                    text: Wayland.title
                }
            }
        }

        // Right Items
        Item {
            height: 44
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: rightRow.width

            Row {
                id: rightRow
                rightPadding: 8
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -6
                    width: 10
                    height: 2
                    color: ufg
                }

                Item {
                    width: clock.width + 16 + 12
                    height: clock.height + 16

                    Decoration {}

                    Rectangle {
                        width: clock.width + 16
                        height: clock.height + 4
                        color: tbg
                        anchors.centerIn: parent
                        border {
                            width: 2
                            color: ufg
                        }

                        StyledText {
                            id: clock

                            anchors.centerIn: parent
                            color: fg

                            Process {
                                id: dateProc // give the Process an ID so we can reference it in `Timer`

                                command: ["date", "+%T"]
                                running: true

                                stdout: StdioCollector {
                                    onStreamFinished: clock.text = this.text
                                }
                            }

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: dateProc.running = true // every time the timer is triggered, set running to true to rerun `date`
                            }
                        }
                    }
                }

                Item {
                    width: volumeText.width + 16 + 12
                    height: volumeText.height + 16

                    Rectangle {
                        width: volumeText.width + 16
                        height: volumeText.height + 4
                        color: tbg
                        anchors.centerIn: parent
                        border {
                            width: 2
                            color: ufg
                        }

                        StyledText {
                            id: volumeText
                            anchors.centerIn: parent
                            color: fg
                            text: "10% (fake)"
                        }
                    }
                    Decoration {
                        end: true
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 6
                    width: 10
                    height: 2
                    color: ufg
                }
            }
        }
    }
}
