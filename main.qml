import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Shapes 1.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Window {
    id: window
    visible: true
    maximumWidth: 800
    maximumHeight: 600
    minimumWidth: maximumWidth
    minimumHeight: maximumHeight
    color: "#000000"

    Rectangle {
        id: outer_rect
        z: 0
        anchors.centerIn: parent
        height: parent.height / 2
        width: height
        radius: height / 2
        color: "#7777a2"
    }
    Rectangle {
        id: middle_rect
        z: 1
        anchors.centerIn: parent
        height: outer_rect.height - 15
        width: height
        radius: height / 2
        color: "#d1d1d1"
    }
    CircularGauge {
        id: gauge
        z: 2
        anchors.centerIn: parent
        height: middle_rect.height - 40
        width: height
        minimumValue: 0
        maximumValue: 25
        stepSize: 1

        // temporary
        focus: true
        Keys.onLeftPressed: {
            --value;
        }
        Keys.onRightPressed: {
            ++value;
        }
        Keys.onReturnPressed: {
            Qt.quit()
        }
        // temporary

        style: CircularGaugeStyle {
            id: gauge_style
            minimumValueAngle: -80
            maximumValueAngle: 80
            tickmarkStepSize: 2.5
            labelInset: -13

            background: Rectangle {
                id: inner_rect
                radius: gauge.height / 2
                color: "#000000"
            }
            needle: Shape {
                id: needle_shape
                y: -outerRadius * 0.5
                width: 10
                height: 40
                antialiasing: true
                ShapePath {
                    strokeColor: "yellow"
                    fillColor: strokeColor
                    startX: needle_shape.width / 2; startY: 0
                    PathLine { x: 0; y: needle_shape.height }
                    PathLine { x: needle_shape.width; y: needle_shape.height }
                    PathLine { x: needle_shape.width / 2; y: 0 }
                }
            }
            minorTickmark: null
            tickmarkLabel: Text {
                font.pointSize: 12
                text: styleData.value
                visible: styleData.index % 2 ? false : true
            }
            tickmark: Rectangle {
                width: 3
                height: styleData.index % 2 ? 3 : 6
                color: styleData.value >= 15 ? "red" : "gray"
                antialiasing: true
            }
            foreground: Item {
                Item {
                    id: texts
                    anchors.centerIn: parent
                    height: outerRadius
                    width: height
                    Text {
                        id: speed
                        textFormat: Text.RichText
                        width: texts.width
                        height: texts.height - odometer.height
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        font.pointSize: 18
                        text: '<font size="16">' + gauge.value + '</font><font size="3">км/ч</font>'
                    }
                    Text {
                        id: odometer
                        anchors.top: speed.bottom
                        anchors.left: speed.left
                        textFormat: Text.RichText
                        width: texts.width
                        height: 40
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        font.pointSize: 10
                        property int km: 1234567
                        text: '<font size="10">' + km + '</font><font size="4"> км</font>'
                    }
                    Icon {
                        id: hand_brake_icon
                        anchors.top: odometer.bottom
                        anchors.horizontalCenter: odometer.horizontalCenter
                        width: 60
                        height: 43
                        img.source: "qrc:/icons/remove_bg_icons/Hand_brake_remove_bg.png"
                    }
                }
            }
        }
    }

    Shape {
        id: charge_shape
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        antialiasing: true
        width: 90
        height: 75
        property int radius: 6
        ShapePath {
            id: charge_shape_path
            strokeColor: "#cfcfcf"
            strokeStyle: ShapePath.DashLine
            joinStyle: ShapePath.RoundJoin
            fillColor: "transparent"
            strokeWidth: 2
            dashPattern: [4,2]
            startX: charge_shape.radius; startY: 0
            PathLine { x: charge_shape.width - charge_shape.radius; y: 0 }
            PathArc {
                x: charge_shape.width;
                y: charge_shape.radius
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
            PathLine { x: charge_shape.width; y: charge_shape.height - charge_shape.radius }
            PathArc {
                x: charge_shape.width - charge_shape.radius;
                y: charge_shape.height
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
            PathLine { x: charge_shape.radius; y: charge_shape.height }
            PathArc {
                x: 0;
                y: charge_shape.height - charge_shape.radius
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
            PathLine { x: 0; y: charge_shape.radius }
            PathArc {
                x: charge_shape.radius;
                y: 0
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
        }
        Icon {
            id: charge_icon
            anchors.centerIn: parent
            width: parent.width - 25
            height: parent.height - 35
            img.source: "qrc:/icons/remove_bg_icons/Charge_remove_bg.png"
        }
    }
    ListView {
        id: charge_view
        anchors.left: charge_shape.left
        anchors.top: charge_shape.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        model: 10
        spacing: 5
        delegate: Delegate {
            what_view: 1
        }
    }
    Shape {
        id: pwr_shape
        anchors.right: parent.right
        anchors.rightMargin: charge_shape.anchors.leftMargin
        anchors.top: parent.top
        anchors.topMargin: charge_shape.anchors.topMargin
        antialiasing: true
        width: charge_shape.width
        height: charge_shape.height
        ShapePath {
            strokeColor: charge_shape_path.strokeColor
            strokeStyle: charge_shape_path.strokeStyle
            joinStyle: charge_shape_path.joinStyle
            fillColor: charge_shape_path.fillColor
            strokeWidth: charge_shape_path.strokeWidth
            dashPattern: charge_shape_path.dashPattern
            startX: charge_shape.radius; startY: 0
            PathLine { x: charge_shape.width - charge_shape.radius; y: 0 }
            PathArc {
                x: charge_shape.width;
                y: charge_shape.radius
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
            PathLine { x: charge_shape.width; y: charge_shape.height - charge_shape.radius }
            PathArc {
                x: charge_shape.width - charge_shape.radius;
                y: charge_shape.height
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
            PathLine { x: charge_shape.radius; y: charge_shape.height }
            PathArc {
                x: 0;
                y: charge_shape.height - charge_shape.radius
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
            PathLine { x: 0; y: charge_shape.radius }
            PathArc {
                x: charge_shape.radius;
                y: 0
                radiusX: charge_shape.radius
                radiusY: radiusX
            }
        }
        Text {
            id: pwr_text
            width: parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 1
            font.pointSize: 30
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            text: "PWR"
            color: "#ffffff"
        }
    }
    ListView {
        id: pwr_view
        anchors.left: pwr_shape.left
        anchors.top: pwr_shape.bottom
        anchors.topMargin: charge_view.anchors.topMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: charge_view.anchors.bottomMargin
        model: charge_view.model
        spacing: charge_view.spacing
        delegate: Delegate {
            what_view: 0
        }
    }

}
