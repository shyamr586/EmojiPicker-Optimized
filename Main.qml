import QtQuick
import QtQuick.Window

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Model {id: myModel}

    Rectangle {
        height: 400; width: parent.width
        anchors.bottom: parent.bottom
        color: "#202c32"

        Row {
            id: row
            anchors {left: parent.left; right: parent.right;}
            bottomPadding: 20
            Repeater {
                model: myModel.jsModel
                MouseArea {
                    height: 50; width: parent.width/myModel.jsModel.length; onClicked: {listViewElem.positionViewAtIndex(index, ListView.Beginning); listViewElem.currentIndex = index;}
                    Item {
                        anchors.fill: parent
                        Text {anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 20}
                        Rectangle {
                            id: highlight
                            anchors.bottom: parent.bottom
                            height: 4; width: parent.width
                            visible: index === listViewElem.currIndex && listViewElem.headerItem.userInput === ""
                            color :"#01a884"
                        }
                    }
                }
            }
        }

        ListView {
            id: listViewElem
            property int currIndex
            anchors {top: row.bottom; bottom: parent.bottom; left: parent.left; right: parent.right; bottomMargin: 20 }
            model: myModel.jsModel
            spacing: 10
            preferredHighlightBegin: 0
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 200
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 10000
            header: Rectangle {
                anchors { left: parent.left; right: parent.right; margins: 10;}
                height: 50
                color: "#222e35"
                z: 999
                radius: 10
                property alias userInput: searched.text
                TextInput {
                    id: searched
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    leftPadding: 10
                    font.pixelSize: 15
                    color: "white"
                    state: "default"
                    Text {text: "Search Emoji"; color: "#798186"; z:-1; leftPadding: parent.leftPadding; visible: !parent.text; font.pixelSize: 15}}
            }
            headerPositioning: listViewElem.headerItem.userInput===""?ListView.PullBackHeader:ListView.OverlayHeader
            clip: true
            delegate: Column{
                spacing: emojiValuesRepeater.count === 0? 0:20
                leftPadding: 20; rightPadding: 20;
                visible: emojiValuesRepeater.count > 0
                height: emojiValuesRepeater.count === 0? 0: childrenRect.height
                Text {text: modelData.category; color: "#798287"; font.pixelSize: 14; font.weight: Font.DemiBold; topPadding: emojiValuesRepeater.count === 0? 0:10}
                Flow {
                    width: listViewElem.width - (parent.leftPadding + parent.rightPadding)
                    spacing: emojiValuesRepeater.count === 0? 0:20
                    anchors.leftMargin: 10
                    Repeater{
                        id: emojiValuesRepeater
                        model: listViewElem.headerItem.userInput!=="" ?
                                   modelData.emojis.filter(elem => elem.description.includes(listViewElem.headerItem.userInput)) : modelData.emojis
                        delegate: Rectangle {
                            height: 30; width: 30;
                            color: "transparent";
                            Text {text: modelData.emoji; anchors.centerIn: parent; font.pixelSize: 30;}}
                    }
                }
            }
            onContentYChanged: {if (indexAt(x,contentY)!==-1){currIndex = indexAt(x,contentY+listViewElem.headerItem.height);}}
        }
    }
}
