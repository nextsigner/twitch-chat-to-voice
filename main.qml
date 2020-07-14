import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebView 1.1
import QtQuick.Window 2.2
ApplicationWindow {
    id: app
    visible: Qt.platform.os!=='android'?false:true
    visibility: Qt.platform.os!=='android'?'Windowed':'Maximized'
    width: Qt.platform.os!=='android'?300:Screen.width
    height: Screen.desktopAvailableHeight
    flags: Qt.platform.os!=='android'?Qt.Window | Qt.FramelessWindowHint:app.flags// | Qt.WindowStaysOnTopHint
    x:Qt.platform.os!=='android'?Screen.width-width:0
    color: Qt.platform.os!=='android'?'transparent':'red'
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
    property string moderador:''
    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    USettings{
        id: unikSettings
        url:app.moduleName+'.cfg'
        onCurrentNumColorChanged: setVars()
        Component.onCompleted: {
            if(Qt.platform.os!=='android'){
                setVars()
            }
        }
        function setVars(){
            let m0=defaultColors.split('|')
            let ct=m0[currentNumColor].split('-')
            app.c1=ct[0]
            app.c2=ct[1]
            app.c3=ct[2]
            app.c4=ct[3]
        }
    }
    Item{
        id: xApp
        anchors.fill: parent
        Rectangle{
            anchors.fill: parent
            WebView{
                id: wv
                anchors.fill: parent

                onLoadProgressChanged: {
                    if(loadProgress===100)tCheck.start()
                }
            }
        }
        XSetMod{
            id: xSetMod
            width: xApp.width
            anchors.horizontalCenter: parent.horizontalCenter
            z: wv.z+1000
                Timer{
                    running: true
                    repeat: true
                    interval: 100
                    onTriggered: xSetMod.z++
                }
        }
        //ULogView{id: uLogView}
        //UWarnings{id: uWarnings}
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
            //            if(uLogView.visible){
            //                uLogView.visible=false
            //                return
            //            }
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
                app.url='https://www.twitch.tv/embed/'+user+'/chat?parent=nextsigner.github.io'
                console.log('app.url: '+app.url)
            }
            if(args[i].indexOf('-launch')>=0){
                launch=true
            }
        }
        //app.url='https://www.twitch.tv/embed/nextsigner/chat?parent=nextsigner.github.io'
        if(user===''){
            app.visible=true
            xSetMod.visible=true
            return
        }
        wv.url=app.url
        if(launch){
            Qt.openUrlExternally(app.url)
        }

        //Depurando
        app.visible=true
        //getViewersCount()
    }
    function setDesktopIcon(params){
        let path=pws+"/"+app.moduleName
        if(Qt.platform.os==='windows'){
            if(!unik.folderExist(path)){
                unik.mkdir(path)
                app.l(path)
            }
            unik.createLink(unik.getPath(1)+"/unik.exe", " "+params+" -git=https://github.com/nextsigner/"+app.moduleName+".git",  unik.getPath(7)+"/Desktop/Update-"+app.moduleName.toUpperCase()+".lnk", "Update-"+app.moduleName.toUpperCase()+"", path);
        }
    }
}

