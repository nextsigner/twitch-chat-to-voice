import QtQuick 2.0

Item {
    id: r
    width: w
    height: w
    property int numShot: 0
    property int w: app.fs*3
    property color c1: 'red'
    Behavior on x{
        NumberAnimation{duration: 50; easing.type: Easing.InOutQuad}
    }
    Rectangle{
        width: r.w
        height: width
        color: 'transparent'
        border.width: 1
        border.color: 'red'
    }
    Image {
        id: img1
        source: "file:./img/p1.png"
        anchors.centerIn: r
        width: r.w
        height: r.w
    }
    function r(){
        if(x>parent.width-width)return
        x+=10
    }
    function l(){
        if(r.x-10<0)return
        r.x-=10
    }
    function s(){
        let ws=app.fs
        let comp=Qt.createComponent("M1.qml")
        let obj=comp.createObject(r.parent, {w: ws, x: r.x+r.width*0.5-ws*0.5, y:r.y, objectName: 'obj'+r.numShot})
        //let obj=comp.createObject(r.parent, {w: ws, x: r.x+r.width*0.5-ws*0.5, y:r.y, objectName: 'obj1'})

        r.numShot++
    }
}
