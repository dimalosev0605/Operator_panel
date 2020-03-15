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
        Keys.onUpPressed: {
            if(wheel_turn.x < wheel_turn_frame.width - wheel_turn.width - line_repeater.line_width * 2)
                wheel_turn.x += line_repeater.line_width * 2
        }
        Keys.onDownPressed: {
            if(wheel_turn.x > line_repeater.line_width)
                wheel_turn.x -= line_repeater.line_width * 2
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
                    id: gauge_info
                    anchors.centerIn: parent
                    height: outerRadius
                    width: height
                    Text {
                        id: speed
                        textFormat: Text.RichText
                        width: gauge_info.width
                        height: gauge_info.height - odometer.height
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignHCenter
                        color: "#ffffff"
                        font.pointSize: 18
                        text: '<font size="16">' + gauge.value + '</font><font size="3">км/ч</font>'
                    }
                    Text {
                        id: odometer
                        anchors.top: speed.bottom
                        anchors.left: speed.left
                        textFormat: Text.RichText
                        width: gauge_info.width
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
        anchors.right: charge_shape.right
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

    Rectangle {
        id: wheel_turn_frame
        z: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: charge_view.right
        anchors.leftMargin: 10
        anchors.right: pwr_view.left
        anchors.rightMargin: 10
        height: 50
        border.width: line_repeater.line_width
        border.color: "#d1d1d1"
        radius: 5
        color: "#000000"
        Repeater {
            id: line_repeater
            model: 11
            property int space: wheel_turn_frame.width / (count + 1)
            property int line_width: 2
            Rectangle {
                z: 2
                x: (index + 1) * line_repeater.space
                y: 6
                width: line_repeater.line_width
                height: wheel_turn_frame.height - y * 2
                color: wheel_turn_frame.border.color
            }
        }
        Rectangle {
            id: wheel_turn
            z: 1
            x: wheel_turn_frame.border.width * 1 + line_repeater.space * 5
            y: wheel_turn_frame.border.width * 2
            height: wheel_turn_frame.height - y * 2
            color: "#00ff00"
            width: line_repeater.space * 2 - line_repeater.line_width
        }
    }
    Row {
        id: digital_info_row
        anchors.left: wheel_turn_frame.left
        anchors.right: wheel_turn_frame.right
        anchors.bottom: wheel_turn_frame.top
        anchors.bottomMargin: 10
        anchors.top: outer_rect.bottom
        anchors.topMargin: 10
        spacing: 10
        property int count_of_columns: 5
        property int item_width: (digital_info_row.width - digital_info_row.spacing * (digital_info_row.count_of_columns - 1)) /
               digital_info_row.count_of_columns
        property int item_height: digital_info_row.height
        property int font_point_size: 7
        Text {
            id: hydsys_oil_temp
            width: digital_info_row.item_width
            height: digital_info_row.item_height
            textFormat: Text.RichText
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: digital_info_row.font_point_size
            text: '<font size="16" color="gray">105</font><font size="5" color="gray"> C\u00B0</font><br><br><font size="4" color="white">ТЕМП. МАСЛА<br><br>ГИДРОСИСТЕМЫ</font>'
        }
        Text {
            id: hydsys_oil_pressure
            width: digital_info_row.item_width
            height: digital_info_row.item_height
            textFormat: Text.RichText
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: digital_info_row.font_point_size
            text: '<font size="16" color="gray">10.1</font><font size="5" color="gray"> МПа</font><br><br><font size="4" color="white">ДАВЛ. МАСЛА<br><br>ГИДРОСИСТЕМЫ</font>'
        }
        Text {
            id: oil_pressure_diff
            width: digital_info_row.item_width
            height: digital_info_row.item_height
            textFormat: Text.RichText
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: digital_info_row.font_point_size
            text: '<font size="16" color="gray">0.3</font><font size="5" color="gray"> Мпа</font><br><br><font size="4" color="white">ДАВЛ. МАСЛА<br><br>ПЕРЕПАД</font>'
        }
        Text {
            id: left_cool_liquid_temp
            width: digital_info_row.item_width
            height: digital_info_row.item_height
            textFormat: Text.RichText
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: digital_info_row.font_point_size
            text: '<font size="16" color="gray">75</font><font size="5" color="gray"> C\u00B0</font><br><br><font size="4" color="white">ТЕМП. ЖИДК.<br><br>СВО ЛЕВ. СТ.</font>'
        }
        Text {
            id: right_cool_liquid_temp
            width: digital_info_row.item_width
            height: digital_info_row.item_height
            textFormat: Text.RichText
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: digital_info_row.font_point_size
            text: '<font size="16" color="gray">85</font><font size="5" color="gray"> C\u00B0</font><br><br><font size="4" color="white">ТЕМП. ЖИДК.<br><br>СВО ПРАВ. СТ.</font>'
        }
    }
}
