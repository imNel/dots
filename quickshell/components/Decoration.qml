import QtQuick

Item {
    id: root
    property bool end: false
    anchors.fill: parent

    Rectangle {
        width: 2
        height: parent.height
        color: ufg
        anchors.right: end ? parent.right : undefined
        anchors.left: end ? undefined : parent.left
    }

    Row {
        spacing: 4
        anchors.right: end ? parent.right : undefined
        anchors.left: end ? undefined : parent.left
        anchors.bottom: parent.bottom

        Rectangle {
            width: 12
            height: 2
            color: ufg
        }

        Rectangle {
            width: 36
            height: 2
            color: ufg
        }
    }

    Row {
        spacing: 4
        anchors.right: end ? parent.right : undefined
        anchors.left: end ? undefined : parent.left

        Rectangle {
            width: 12
            height: 2
            color: ufg
        }

        Rectangle {
            width: 36
            height: 2
            color: ufg
        }
    }
}
