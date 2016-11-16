import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true
    width: 960
    height: 600
    title: qsTr("Hello World")
/*
    Canvas{
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.Image
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(parent.width/2, parent.height/2);
            ctx.arc(parent.width/2, parent.height/2, 100, 0, Math.PI / 2, true);
            //ctx.rotate(Math.PI / 4);
            //ctx.arc(parent.width/2, parent.height/2, 100, 0, Math.PI / 2, true);
            ctx.closePath();



            ctx.lineWidth = 4;
            ctx.strokeStyle = "red";
            ctx.stroke();
        }
    }

*/
    PetalControl{
        //anchors.fill: parent
        width: 400
        height: 400
        anchors.centerIn: parent

        model: ListModel{
            ListElement{
                icon: "qrc:/icons/front.png"
                info: "Step1 wow"
                color: "#FF2468"
            }
            ListElement{
                icon: "qrc:/icons/bottom.png"
                info: "Step2 wow"
                color: "#E0D4B1"
            }
            ListElement{
                icon: "qrc:/icons/right.png"
                info: "Step3 wow"
                color: "#00A5A6"
            }
            ListElement{
                icon: "qrc:/icons/left.png"
                info: "Step4 wow"
                color: "#005B63"
            }
            ListElement{
                icon: "qrc:/icons/left.png"
                info: "Step5 wow"
                color: "#3F1103"
            }
            ListElement{
                icon: "qrc:/icons/left.png"
                info: "Step5 wow"
                color: "#ff1103"
            }
            ListElement{
                icon: "qrc:/icons/left.png"
                info: "Step5 wow"
                color: "#ffff03"
            }
        }
    }
}
