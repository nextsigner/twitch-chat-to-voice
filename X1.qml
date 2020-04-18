import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width*0.8
    height: parent.height
    color: '#333'
    border.width: 2
    border.color: 'red'
    P1{
        id: p1
        anchors.bottom: parent.bottom
        Component.onCompleted: {
            app.p1=p1
        }
    }
    function a(){
        let wa=app.fs*2
        let comp=Qt.createComponent("U1.qml")
        let obj=comp.createObject(r, {w: wa, y:0})
    }
}

