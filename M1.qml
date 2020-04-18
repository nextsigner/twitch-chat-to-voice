import QtQuick 2.0

Item {
    id: r
    width: app.fs
    height: width
    property var foo
    onYChanged:{
        if(y<0-r.height){
            r.destroy(1)
        }
    }
    Behavior on y{
        NumberAnimation{duration: 10000; easing.type: Easing.InCirc}
    }
    Rectangle{
        id: bg
        anchors.fill: r
        radius: width*0.5
    }
//    Timer{
//        running: true
//        repeat: true
//        interval: 10
//        onTriggered: {
//            //let obj=app.coords
//            //function Foo(){}
//            r.foo = {x:r.x, y:r.y};
//            app.coords[r.objectName]=r.foo
//        }
//    }
    Component.onCompleted: {
        r.y=0-r.height-50
    }
}
