import QtQuick 2.14

Rectangle {
    id: icon
    property string img_source
    property bool is_active: false
    color: "#000000"

    Image {
        id: img
        anchors.fill: parent
        source: is_active ? img_source.replace("_passive.png", ".png") : img_source
    }
}
