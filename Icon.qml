import QtQuick 2.14

Rectangle {
    id: icon
    property alias img: img
    property bool is_active: false
    color: is_active ? "#cfcfcf" : "#000000"

    Image {
        id: img
        anchors.fill: parent
    }
}
