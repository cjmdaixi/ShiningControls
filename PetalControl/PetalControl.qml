import QtQuick 2.6
import QtGraphicalEffects 1.0

Item {
    id: root

    width: 300
    height: 300
    // 参数设置接口
    property alias hoverEnabled: mouseArea.hoverEnabled
    property bool stepMode: true
    property var model
    property color disabledBackColor: "grey"

    // 内部参数
    property real radius: width / 5
    property real gap: radius / 8
    property real innerRadius: radius / 10
    property real fanAngle: Math.PI * 2 / model.count
    property real centerX: width / 2
    property real centerY: height / 2
    property var fans: []
    property int currentStep: -1
    property bool isStepsFinished: false

    property real sizeRef: radius / model.count

    signal clicked(int fanIndex)
    signal entered(int fanIndex)
    signal exited(int fanIndex)
    signal stepsFinished()

    property bool initFinished: false

    function createFans(){
        for (var i = 0; i !== model.count; ++i){
            var fanInfo = model.get(i);
            var fan = stepDelegate.createObject(root, {"normalBackColor": fanInfo.backColor, "index": i, "enabled": !stepMode});
            fan.rotation = fanAngle * i * (180 / Math.PI);
            //console.log("one fan", fan.index, "is created");
            root.fans.push(fan);
            var pos = mapFromItem(fan, centerX, centerY - gap * 6);
            var num = numDelegate.createObject(root, {"color": fanInfo.contentColor, "index": i + 1, "centerPos": pos});

            var outerArcCenter = fan.outerArcCenter;

            pos = mapFromItem(fan, outerArcCenter.x, outerArcCenter.y);
            //console.log(i, "outerArcCenter", pos);
            var icon = iconDelegate.createObject(root, {"iconSource": fanInfo.icon, "color": fanInfo.contentColor, "centerPos": pos});
        }
    }

    function resetSteps(){
        console.log("reset steps");
        isStepsFinished = false;
        currentStep = -1;
        for(var i = 0; i !== fans.length; ++i){
            fans[i].enabled = false;
        }
    }

    function nextStep(){
        console.log("next step", currentStep);
        currentStep++;
        fans[currentStep].enabled = true;
        if((currentStep + 1) === model.count){
            stepsFinished();
            isStepsFinished = true;
        }
    }

    Component.onCompleted:{
        //console.log("create fans...");
        createFans();
        initFinished = true;
        //console.log("sizeref:", sizeRef);
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: {
            for(var i = 0; i !== root.fans.length; ++i){
                var fan = root.fans[i];
                if(fan.enabled && fan.beenHovered &&
                        fan.mouseInside(mapToItem(fan, mouse.x, mouse.y)) === false){
                    fan.beenHovered = false;
                    fan.beenPressed = false;
                    root.exited(fan.index);
                    //console.log("fan", fan.index, "exited");
                    break;
                }
            }

            for(i = 0; i !== root.fans.length; ++i){
                fan = root.fans[i];
                if(fan.enabled && !fan.beenHovered &&
                        fan.mouseInside(mapToItem(fan, mouse.x, mouse.y))){
                    fan.beenHovered = true;
                    root.entered(fan.index);
                    //console.log("fan", fan.index, "entered");
                    break;
                }
            }
        }

        onPressed: {
            for(var i = 0; i !== root.fans.length; ++i){
                var fan = root.fans[i];
                if(fan.enabled && fan.mouseInside(mapToItem(fan, mouse.x, mouse.y))){
                    //console.log("fan", fan.index, "pressed");
                    fan.beenPressed = true;
                    return;
                }
            }
        }

        onReleased: {
            for(var i = 0; i !== root.fans.length; ++i){
                var fan = root.fans[i];
                if(fan.enabled && fan.beenPressed &&
                        fan.mouseInside(mapToItem(fan, mouse.x, mouse.y))){
                    //console.log("fan", fan.index, "clicked");
                    fan.beenPressed = false;
                    root.clicked(fan.index);
                    return;
                }
            }
        }
    }

    Component{
        id: iconDelegate
        Item {
            id: delegateRoot
            property color color: "white"
            property point centerPos
            property alias iconSource: iconCtrl.source
            width: 3.5 * root.sizeRef
            height: width
            x: centerPos.x - width / 2
            y: centerPos.y - height / 2
            Image{
                id: iconCtrl
                visible: false
                smooth: true
                mipmap: true
                anchors.fill: parent
            }

            ColorOverlay {
                id: iconColor
                source: iconCtrl
                color: delegateRoot.color
                anchors.fill: iconCtrl
            }
        }
    }

    Component{
        id: numDelegate
        Text {
            id: stepNumCtrl
            property int index: 0
            property point centerPos: Qt.point(0, 0)

            text: ("0" + index).slice(-2);
            font{family: "Microsoft YaHei"; pointSize: root.sizeRef * 1.3; bold: true}
            x: centerPos.x - contentWidth / 2
            y: centerPos.y - contentHeight / 2
        }
    }

    Component{
        id: stepDelegate
        Item{
            id: delegateRoot
            anchors.fill: parent

            property color normalBackColor: "red"
            property alias canvas: backCanvas
            property int index: 0
            property bool beenHovered: false
            property bool beenPressed: false
            property real centerX: root.centerX
            property real centerY: root.centerY - root.gap
            property point innerArcCenter: Qt.point(centerX, centerY - root.innerRadius / Math.sin(root.fanAngle / 2));
            property point outerArcCenter: Qt.point(centerX, centerY - root.radius / Math.cos(root.fanAngle / 2));
            property real outerRadius: root.radius * Math.tan(root.fanAngle / 2);
            property color backgroundColor: delegateRoot.normalBackColor

            onBackgroundColorChanged: canvas.requestPaint();

            function mouseInside(pt){
                var ctx = canvas.getContext("2d");
                if (ctx.isPointInPath(pt.x, pt.y)){
                    return true;
                }else{
                    return false;
                }
            }

            states:[
                State{
                    name: "disabled"
                    when: !delegateRoot.enabled
                    PropertyChanges {
                        target: delegateRoot
                        backgroundColor: root.disabledBackColor
                    }
                },
                State{
                    name: "pressed"
                    when: delegateRoot.beenHovered && delegateRoot.beenPressed && delegateRoot.enabled
                    PropertyChanges {
                        target: delegateRoot
                        backgroundColor: Qt.darker(delegateRoot.normalBackColor)
                    }
                },
                State{
                    name: "hovered"
                    when: delegateRoot.beenHovered && delegateRoot.enabled
                    PropertyChanges {
                        target: delegateRoot
                        backgroundColor: Qt.lighter(delegateRoot.normalBackColor, 1.3)
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "*"
                    to: "*"
                    enabled: root.initFinished
                    ColorAnimation{duration: 300}
                }
            ]

            Canvas{
                id: backCanvas
                renderTarget: Canvas.Image
                antialiasing: true
                anchors.fill: parent
                onPaint: {
                    var alpha = (Math.PI - root.fanAngle) / 2;
                    var a = Qt.point(delegateRoot.centerX + root.radius * Math.cos(alpha), delegateRoot.centerY - root.radius * Math.sin(alpha));
                    //console.log("point a:", a);
                    var bX = root.innerRadius * Math.cos(root.fanAngle / 2);
                    var b = Qt.point(delegateRoot.centerX - bX, delegateRoot.centerY - bX / Math.tan(root.fanAngle / 2));
                    //console.log("point b:", b);

                    var innerArcStartAngle = Math.PI - root.fanAngle / 2;
                    var innerArcEndAngle = root.fanAngle / 2;
                    var outerArcStartAngle = root.fanAngle / 2;
                    var outerArcEndAngle = Math.PI - root.fanAngle / 2;

                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    ctx.fillStyle = delegateRoot.backgroundColor;
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = "green";
                    ctx.beginPath();
                    ctx.moveTo(a.x, a.y);
                    ctx.arc(delegateRoot.outerArcCenter.x, delegateRoot.outerArcCenter.y,
                            delegateRoot.outerRadius, outerArcStartAngle, outerArcEndAngle, true);
                    ctx.lineTo(b.x, b.y);
                    ctx.arc(delegateRoot.innerArcCenter.x, delegateRoot.innerArcCenter.y,
                            root.innerRadius, innerArcStartAngle, innerArcEndAngle, true);
                    ctx.closePath();
                    ctx.fill();
                    //ctx.stroke();
                }
            }
        }
    }
}
