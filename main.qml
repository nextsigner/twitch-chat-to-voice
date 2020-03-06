import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4
import QtQuick.Window 2.2
import "qrc:/"
ApplicationWindow {
    id: app
    visible: false
    width: 300
    height: Screen.desktopAvailableHeight
    flags: Qt.Window | Qt.FramelessWindowHint// | Qt.WindowStaysOnTopHint
    x:Screen.width-width
    color: 'transparent'
    property string moduleName: 'tcv'
    property int fs: app.width*0.035
    property color c1: 'black'
    property color c2: 'white'
    property color c3: 'gray'
    property color c4: 'red'
    property string uHtml: ''
    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    USettings{
        id: unikSettings
        url:'./'+app.moduleName
    }
    Item{
        id: xApp
        anchors.fill: parent
        Rectangle{
            anchors.fill: parent
            WebEngineView{
                id: wv
                anchors.fill: parent
            }
        }
        XChat{id:xChat}
        ULogView{id: uLogView}
        UWarnings{id: uWarnings}

    }
    Row{
        spacing: app.fs*3
        Boton{
            w:app.fs*2
            h:w
            t:'R'
            onClicking:{
                //xChat.visible=!xChat.visible
                setMsg('Mensaje de prueba')
            }
        }
        Boton{
            w:app.fs*2
            h:w
            t:'R2'
            onClicking:{
                //xChat.visible=!xChat.visible
                sendMsg()
            }
        }
    }

    Timer{
        id:tCheck
        running: true
        repeat: true
        interval: 500
        onTriggered: {
            wv.runJavaScript('document.getElementById("root").innerText', function(result) {
                if(result!==app.uHtml){
                    let d0=result//.replace(/\n/g, 'XXXXX')
                    if(d0.indexOf(':')>0){
                        let d1=d0.split(':')
                        let d2=d1[d1.length-1]
                        let d3=d2.split('Enviar')
                        let mensaje = d3[0]

                        let d5=d0.split('\n\n')
                        let d6=d5[d5.length-3]
                        let d7=d6.split(':')
                        let d8=d7[0].split(' ')
                        let usuario=d8[d8.length-1].replace('chat\n', '')
                        unik.speak(usuario+' dice '+mensaje)
                        xChat.log(usuario+': '+mensaje+'<br />')
                        app.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                        app.flags = Qt.Window | Qt.FramelessWindowHint
                    }
                }
                app.uHtml=result
            });
        }
    }
    Component.onCompleted: {
        wv.url='https://www.twitch.tv/embed/nextsigner/chat'
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
}

