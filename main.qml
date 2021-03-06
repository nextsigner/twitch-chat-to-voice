import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebView 1.1
import QtQuick.Window 2.2
ApplicationWindow {
    id: app
    visible: Qt.platform.os!=='android'?false:true
    visibility: Qt.platform.os!=='android'?'Windowed':'Maximized'
    width: Screen.width*0.8//Qt.platform.os!=='android'?300:Screen.width
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
    property var mods: ['ricardo__martin', 'nextsigner', 'lucssagg']
    property var ue: ['ricardo__martin', 'lucssagg', 'nextsigner']
    property bool allSpeak: true
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
    onClosing: {
        if(Qt.platform.os==='android'){
            if(wv.visible){
                wv.visible=false
                close.accepted = false
            }else{
                close.accepted = true
            }
        }
    }
    Item{
        id: xApp
        anchors.fill: parent
        Row{
            //Url texto a voz http://texttospeechrobot.com/tts/es/texto-a-voz/
            Rectangle{
                width: app.width*0.5
                height: app.height
                color: '#ff8833'
                WebView{
                    id: wvtav
                    url: 'http://texttospeechrobot.com/tts/es/texto-a-voz/'
                    anchors.fill: parent
                }
            }
            Rectangle{
                width: app.width*0.5
                height: app.height
                color: '#ff8833'
                WebView{
                    id: wv
                    anchors.fill: parent
                    visible: false
                    onUrlChanged: {
                        if((''+url)==='https://www.twitch.tv/?no-reload=true'){
                            let c='<iframe frameborder="0"
        scrolling="no"
        id="chat_embed"
        src="https://www.twitch.tv/embed/nextsigner/chat?parent=nextsigner.github.io"
        height="500"
        width="350">
</iframe>'
                            //wv.loadHtml(c)
                            //app.url='http://twitch.tv/nextsigner/embed'
                            //app.url='https://www.twitch.tv/login?no-mobile-redirect=true'
                            wv.url=app.url
                            wv.visible=true
                        }
                    }
                    onLoadProgressChanged: {
                        if(loadProgress===100){
                            //                        if((''+wv.url)==='http://twitch.tv/nextsigner/embed'){
                            //                            app.url='https://www.twitch.tv/embed/nextsigner/chat?parent=nextsigner.github.io'
                            //                            wv.url=app.url
                            //                            wv.visible=true
                            //                        }
                            wv.visible=true
                            tCheck.start()

                        }
                    }
                }
            }
        }
        XSetMod{
            id: xSetMod
            width: xApp.width
            anchors.horizontalCenter: parent.horizontalCenter
        }
        //ULogView{id: uLogView}
        //UWarnings{id: uWarnings}



    }
    //    UText{
    //        text: 'Url: '+wv.url
    //        width: xApp.width
    //        color: 'red'
    //        font.pixelSize: app.fs*4
    //        wrapMode: Text.WrapAnywhere
    //    }
    Timer{
        id:tCheck
        running: false
        repeat: true
        interval: 200
        onTriggered: {
            wv.runJavaScript('document.getElementById("root").innerText', function(result) {
                if(result!==app.uHtml){
                    let d0=result//.replace(/\n/g, 'XXXXX')
                    app.uHtml=result
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
                        let user=''+usuario.replace(/\n/g, '' )

                        if(isVM(msg)&&(''+msg).indexOf('chat.whatsapp.com')<0&&(''+mensaje).indexOf('!')!==1){
                            console.log('u['+usuario+'] '+app.ue.toString())
                            if(app.ue.indexOf(usuario)>=0 || app.allSpeak){
//                                if(Qt.platform.os==='windows'){
//                                    unik.speak(msg)
//                                }else{
                                    console.log(msg)
                                    if(user.indexOf('itomyy17')>=0){
                                        unik.speak(msg)
                                    }else{
                                        speakMp3(msg)
                                    }
                                //}

                            }
                        }
                        if(isVM(msg)&&(''+msg).indexOf('chat.whatsapp.com')<0&&(''+mensaje).indexOf('!')===1&&app.mods.indexOf(user)>=0){
                            let m0=mensaje.split('!')
                            let m1=m0[1].split(' ')
                            let paramUser=m1[1].replace(/\n/g, '' )
                            //Set all speak
                            if(m1[0].length>1&&m1[0]==='alls'){
                                app.allSpeak=!app.allSpeak
                                if(app.allSpeak){
                                    unik.speak("Ahora se oirán todos los mensajes del chat.")
                                }else{
                                    unik.speak("Ahora solo algunos usuarios del chat se oirán.")
                                }
                            }
                            //Add user speak
                            if(m1[0].length>1&&m1[0]==='as'){
                                if(app.ue.indexOf(paramUser)<0){
                                    unik.speak("Se agrega para hablar a "+paramUser)
                                    app.ue.push(paramUser)
                                }else{
                                    unik.speak(paramUser+' ya estaba agregado.')
                                }
                            }
                            //Remove user speak
                            if(m1[0].length>1&&m1[0]==='rs'){
                                if(app.ue.indexOf(paramUser)>=0){
                                    unik.speak("Se quita para hablar a "+paramUser)
                                    app.ue.pop(paramUser)
                                }else{
                                    unik.speak(paramUser+' no estaba agregado.')
                                }
                            }
                            //Set volume speak
                            if(m1[0].length>1&&m1[0]==='sv'){
                                if(app.ue.indexOf(paramUser)>=0){
                                    unik.setTtsVolume(parseInt(paramUser))
                                }else{
                                    unik.speak('El comando no se ha aplicado. Falta el valor del volumen.')
                                }
                            }
                            app.uHtml=result
                            return
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
    Shortcut{
        sequence: 'Ctrl+a'
        onActivated: {
            //TextArea[2] es el de MP3 Convert

            //getElementsByTagName("LI")[0].innerHTML

        }
        Component.onCompleted: {
            unik.setTtsVolume(100)
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
                //unik.speak('Idioma Español seleccionado.')
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
            if(Qt.platform.os==='android'){
                user='nextsigner'
                //app.url='https://m.twitch.tv/login'
                //app.url='https://m.twitch.tv/login?client_id=nextsigner&desktop-redirect=true'
                app.url='https://www.twitch.tv/login?no-mobile-redirect=true'
                //app.url='https://www.twitch.tv/embed/nextsigner/chat?parent=nextsigner.github.io'
            }
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
    }
    function isVM(m){
        let s1='Nightbot'
        if(m.indexOf(s1)>=0)return false;
        let s2='StreamElements'
        if(m.indexOf(s2)>=0)return false;
        let s3='[Juego dice]'
        if(m.indexOf(s3)>=0)return false;
        let s4='Podes enviar audios por whatsapp'
        if(m.indexOf(s4)>=0)return false;
        return true
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
    function speakMp3(text){
        console.log("Convirtiendo a MP3: "+text)
        let nText=(''+text).replace(/\n/g, '')
        console.log("Convirtiendo a MP3: "+text)
        wvtav.runJavaScript('document.getElementsByTagName("TEXTAREA").length', function(result) {
            console.log('Resultado 1: '+result)
            wvtav.runJavaScript('document.getElementsByTagName("TEXTAREA")[2].value="'+nText+'"', function(result2) {
                console.log('Resultado 2: '+result2)
                wvtav.runJavaScript('document.getElementsByTagName("BUTTON").length', function(result3) {
                    console.log('Resultado 3: '+result3)
                    wvtav.runJavaScript('document.getElementsByTagName("BUTTON")[1].click()', function(result4) {
                        console.log('Resultado 4: '+result4)
                    });
                });
            });
        });
    }
}

