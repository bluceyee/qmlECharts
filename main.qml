import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.4
import QtWebChannel 1.0
import QtWebEngine 1.1

Window {
    visible: true
    width: 800
    minimumWidth: 600
    height: 500
    minimumHeight: 400
    title: qsTr("WebChannel example")  //countDown.start();
    property int y_: 6
    property int x_: 1300
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5

        // 一个具有属性、信号和方法的对象——就像任何普通的Qt对象一样
        QtObject {
            id: someObject

            // ID，在这个ID下，这个对象在WebEngineView端是已知的
            WebChannel.id: "backend"
            signal someSignal(int y,int x);
        }
        Timer{
            id:countDown;
            interval: 1000;
            repeat: true;
            triggeredOnStart: true;

            onTriggered: {
                someObject.someSignal(text)
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.width: 2
            border.color: "blue"

            WebEngineView {
                id: webView
                anchors.fill: parent
                anchors.margins: 5
                url: "qrc:/html/index.html"
                onLoadingChanged: {
                    if (loadRequest.errorString)
                    { console.error(loadRequest.errorString); }
                }
                webChannel: channel
            }

            WebChannel {
                id: channel
                registeredObjects: [someObject]
            }
        }

        Button {
            id: button
            text: qsTr("添加数据")
            onClicked: {
                y_ += 1
                x_ += 100
                someObject.someSignal(y_,x_)
            }
        }
    }
}
