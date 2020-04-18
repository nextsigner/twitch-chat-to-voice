import QtQuick 2.0

Item {
    id: r
    width: w
    height: w
    property int w: app.fs*3
    property color c1: 'red'
    onYChanged:{
        if(r.y>r.parent.height){
            r.destroy(10)
        }
    }
    Behavior on x{
        NumberAnimation{duration: 50; easing.type: Easing.InOutQuad}
    }
    Behavior on y{
        NumberAnimation{id: nay; duration: 10000; easing.type: Easing.InOutQuad}
    }
    Rectangle{
        id: bg
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
        rotation: 180
    }
    Timer{
        running: true
        repeat: true
        interval: 10
        onTriggered: {
            let cant=0
            for(let i=0;i<x1.children.length;i++){
                let obj=x1.children[i]
                if(obj.objectName.indexOf('obj')===0){
                    if(obj.y+r.height>=r.y&&obj.y-r.height<r.y&&obj.x+r.width>=r.x&&obj.x-r.width<r.x){
                        stop()
                        r.e()
                    }
                    cant++
                }
            }
        }
    }
    Component.onCompleted: {
        r.y=r.parent.height+r.height+100
    }
    function r(){
        x+=10
    }
    function l(){
        x-=10
    }
    function s(){
        let ws=app.fs
        let comp=Qt.createComponent("M1.qml")
        let obj=comp.createObject(r.parent, {w: ws, x: r.x+r.width*0.5-ws*0.5, y:r.y})
    }
    function e(){
        unik.speak('Destruido')
        r.destroy(1)
    }
}
