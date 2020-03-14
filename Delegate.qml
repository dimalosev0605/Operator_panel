import QtQuick 2.14

Rectangle {
    property int what_view // 0 -> pwr_view; 1 -> charge_view

    width: charge_shape.width
    height: (charge_view.height - (charge_view.count - 1) * charge_view.spacing) / charge_view.count
    radius: 5
    color: if(what_view) {
               if(index === 6 || index === 7) {
                   "#ddff00"
               }
               else if(index === 8 || index === 9) {
                   "#ff0000"
               }
               else {
                   "#00ff00"
               }
           }
           else {
               if(index === 0 || index === 1) {
                   "#ff0000"
               }
               else if(index === 2 || index === 3) {
                   "#ddff00"
               }
               else {
                   "#00ff00"
               }
           }
}
