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
    property bool voiceEnabled: true
    property string user: ''
    property string url: ''
    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    USettings{
        id: unikSettings
        url:pws+'/'+app.moduleName
    }
    Item{
        id: xApp
        anchors.fill: parent
        Rectangle{
            anchors.fill: parent
            WebEngineView{
                id: wv
                anchors.fill: parent
                onLoadProgressChanged: {
                    if(loadProgress===100)tCheck.start()
                }
            }
        }
        ULogView{id: uLogView}
        UWarnings{id: uWarnings}
    }
    Timer{
        id:tCheck
        running: false
        repeat: true
        interval: 1000
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
                        let d7=d0.split(':')
                        let d8=d7[d7.length-2].split('\n')
                        let usuario=''+d8[d8.length-1].replace('chat\n', '')
                        let msg=usuario+' dice '+mensaje
                        if((''+msg).indexOf('chat.whatsapp.com')<0&&(''+mensaje).indexOf('!')!==1){
                            unik.speak(msg)
                        }
                        if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('show')>=0){
                            app.visible=true
                        }
                        if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('hide')>=0){
                            app.visible=false
                        }
                        if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('launch')>=0){
                            Qt.openUrlExternally(app.url)
                        }
                        app.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                        app.flags = Qt.Window | Qt.FramelessWindowHint
                    }
                }
                app.uHtml=result
                //uLogView.showLog(result)
            });
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(uLogView.visible){
                uLogView.visible=false
                return
            }
            Qt.quit()
        }
    }
    Component.onCompleted: {
        if(Qt.platform.os==='linux'){
        let m0=(''+ttsLocales).split(',')
        let index=0
        for(var i=0;i<m0.length;i++){
            console.log('Language: '+m0[i])
            if((''+m0[i]).indexOf('Spanish (Spain)')>=0){
                index=i
                break
            }
        }
        unik.ttsLanguageSelected(index)
        unik.speak('Idioma Español seleccionado.')
        }
        let user=''
        let launch=false
        let args = Qt.application.arguments
        //uLogView.showLog(args)
        for(var i=0;i<args.length;i++){
            //uLogView.showLog(args[i])
            if(args[i].indexOf('-twitchUser=')>=0){
                let d0=args[i].split('-twitchUser=')
                //uLogView.showLog(d0[1])
                user=d0[1]
                app.user=user
                app.url='https://www.twitch.tv/embed/'+user+'/chat'
                uLogView.showLog('Channel: '+app.url)
            }
            if(args[i].indexOf('-launch')>=0){
                launch=true
            }
        }
        wv.url=app.url
        if(launch){
            Qt.openUrlExternally(app.url)
        }

        //Depurando
        app.visible=true
        //getViewersCount()
    }

    function getViewersCount(){
        //https://api.twitch.tv/kraken/streams?channel=nextsigner&client_id=wfvvsxt224sno6ek4ou54tipei87bg
        //"E:/nsp/unik-dev-apps/twitch-chat-to-voice/curl/bin/curl.exe" -H 'Client-ID: wfvvsxt224sno6ek4ou54tipei87bg' -X GET 'https://api.twitch.tv/helix/streams?channel=nextsigner'
        var req = new XMLHttpRequest();
        req.open('GET', 'https://api.twitch.tv/kraken/streams?channel=nextsigner&client_id=wfvvsxt224sno6ek4ou54tipei87bg', true);
        req.onreadystatechange = function (aEvt) {
            if (req.readyState === 4) {
                if(req.status === 200){
                    uLogView.showLog(req.responseText);
                }else{
                    //uLogView.showLog("Error loading page\n");
                }
            }
        };
        req.send(null);
    }
}

