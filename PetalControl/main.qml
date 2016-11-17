import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true
    width: 960
    height: 600
    title: qsTr("PetalControl Demo")

    PetalControl{
        //anchors.fill: parent
        id: petalControl
        focus: true
        Keys.onPressed: {
            console.log("key pressed");
            if(petalControl.isStepsFinished)
                petalControl.resetSteps();
            else
                petalControl.nextStep();
        }
        width: 400
        height: 400
        anchors.centerIn: parent
        stepMode: true
        onStepsFinished: {
            console.log("finished!")
        }
        model: ListModel{
            ListElement{
                icon: "qrc:/icons/action_account_circle.svg"
                info: "Step1 wow"
                backColor: "#FF2468"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/action_autorenew.svg"
                info: "Step2 wow"
                backColor: "#E0D4B1"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/file_file_download.svg"
                info: "Step3 wow"
                backColor: "#00A5A6"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/alert_warning.svg"
                info: "Step4 wow"
                backColor: "#005B63"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/device_access_alarm.svg"
                info: "Step5 wow"
                backColor: "#3F1103"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/image_color_lens.svg"
                info: "Step6 wow"
                backColor: "#ff1103"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/image_edit.svg"
                info: "Step7 wow"
                backColor: "#ffff03"
                contentColor: "white"
            }
            ListElement{
                icon: "qrc:/icons/social_share.svg"
                info: "Step8 wow"
                backColor: "#00ff03"
                contentColor: "white"
            }/**/
        }
    }
}
