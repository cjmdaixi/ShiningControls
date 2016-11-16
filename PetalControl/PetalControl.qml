import QtQuick 2.6

Item {
    id: root

    width: 300
    height: 300

    property real radius: width / 5
    property real gap: radius / 8
    property real innerRadius: radius / 10

    property real fanAngle: Math.PI * 2 / model.count
    property real centerX: width / 2
    property real centerY: height / 2
    property var model

    function createFans(){
        for (var i = 0; i != root.model.count; ++i){
            var fanInfo = root.model.get(i);
            var fan = stepDelegate.createObject(root, {"backgroundColor": fanInfo.color});
            //fan.x = 0;
            //fan.y = 0;
            //fan.width = root.width;
            //fan.height = root.height;
            //fan.transformOrigin = Item.Bottom;
            fan.rotation = root.fanAngle * i * (180 / Math.PI);
            //fan.x = 100 * i;
            console.log("one fan created");
            //return;
        }

    }
    property int updateCount: 0

	Component.onCompleted:{
        console.log("create fans...");
		createFans();
	}

    function updateCanvas(ctx){
        if(root.updateCount == 0){
            ctx.clearRect(0, 0, root.width, root.height);
        }
        root.updateCount = (root.updateCount + 1) ;
    }

    Component{
        id: stepDelegate
        Item{
            id: delegateRoot
            //width: 200
            //height: 200
            //x:0
            //y:0
            anchors.fill: parent
            property color backgroundColor: "red"
            Canvas{
                id: backCanvas
                renderTarget: Canvas.Image
                antialiasing: true
                anchors.fill: parent
                property real centerX: root.centerX
                property real centerY: root.centerY - root.gap
                //onCenterXChanged: requestPaint();
                //onCenterYChanged: requestPaint();
                onPaint: {
                    var alpha = (Math.PI - root.fanAngle) / 2;
                    var a = Qt.point(centerX + root.radius * Math.cos(alpha), centerY - root.radius * Math.sin(alpha));
                    //console.log("point a:", a);
                    var bX = root.innerRadius * Math.cos(root.fanAngle / 2);
                    var b = Qt.point(centerX - bX, centerY - bX / Math.tan(root.fanAngle / 2));
                    //console.log("point b:", b);
                    var outerRadius = root.radius * Math.tan(root.fanAngle / 2);
                    var innerArcCenter = Qt.point(centerX, centerY - root.innerRadius / Math.sin(root.fanAngle / 2));
                    //console.log("innerArcCenter:", innerArcCenter);
                    var outerArcCenter = Qt.point(centerX, centerY - root.radius / Math.cos(root.fanAngle / 2));
                    //console.log("outerArcCenter:", outerArcCenter);
                    var innerArcStartAngle = Math.PI - root.fanAngle / 2;
                    var innerArcEndAngle = root.fanAngle / 2;
                    var outerArcStartAngle = root.fanAngle / 2;
                    var outerArcEndAngle = Math.PI - root.fanAngle / 2;

                    var ctx = getContext("2d");
                    //updateCanvas(ctx);
                    //ctx.clearRect(0, 0, width, height);
                    ctx.fillStyle = delegateRoot.backgroundColor;
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = "green";
                    ctx.beginPath();
                    ctx.moveTo(a.x, a.y);
                    ctx.arc(outerArcCenter.x, outerArcCenter.y, outerRadius, outerArcStartAngle, outerArcEndAngle, true);
                    ctx.lineTo(b.x, b.y);
                    ctx.arc(innerArcCenter.x, innerArcCenter.y, root.innerRadius, innerArcStartAngle, innerArcEndAngle, true);
                    ctx.closePath();
                    ctx.fill();
                    console.log("painted", root.updateCount++);
                    //ctx.stroke();
                }
            }
        }
    }
}
