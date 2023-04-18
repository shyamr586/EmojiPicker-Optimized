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
            anchors { left: parent.left; right: parent.right}
            Repeater {
                model: myModel.jsModel
                MouseArea {
                    height: 50; width: parent.width/myModel.jsModel.length; onClicked: { listViewElem.positionViewAtIndex(index, ListView.Beginning); listViewElem.currentIndex = index }
                    Item {
                        anchors.fill: parent
                        Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 20 }
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
            anchors { top: row.bottom; bottom: parent.bottom; left: parent.left; right: parent.right; bottomMargin: 20 }
            property int currIndex
            model: myModel.jsModel
            preferredHighlightBegin: 50
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 200
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 10000
            clip: true
            header: Rectangle {
                anchors { left: parent.left; right: parent.right; margins: 10 }
                height: 50
                color: "#222e35"
                z: 2
                radius: 10
                property alias userInput: searched.text
                TextInput {
                    id: searched
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    leftPadding: 10
                    font.pixelSize: 15
                    color: "white"
                    Text {text: "Search Emoji"; color: "#798186"; leftPadding: parent.leftPadding; visible: !parent.text; font.pixelSize: 15}
                }
            }
            headerPositioning: listViewElem.headerItem.userInput===""?ListView.PullBackHeader:ListView.OverlayHeader
            delegate: Column {
                id: category
                spacing: emojiValuesRepeater.count === 0 ? 0 : 20
                leftPadding: 20; rightPadding: 20; topPadding: emojiValuesRepeater.count === 0 ? 0 : 10
                visible: emojiValuesRepeater.count !== 0
                Text { id: categoryText; text: modelData.category; visible: emojiValuesRepeater.count === 0 ? false : true; color: "#798287"; font.pixelSize: 14; font.weight: Font.DemiBold }
                Flow {
                    id: emojisFlow
                    width: listViewElem.width - (parent.leftPadding + parent.rightPadding)
                    visible: emojiValuesRepeater.count === 0 ? false : true
                    spacing: emojiValuesRepeater.count === 0 ? 0 : 20
                    Repeater {
                        id: emojiValuesRepeater
                        model: listViewElem.headerItem.userInput!=="" ? modelData.emojis.filter(elem => elem.description.includes(listViewElem.headerItem.userInput)) : modelData.emojis
                        delegate: Text {text: modelData.emoji; font.pixelSize: 30}
                    }
                }
            }
            onContentYChanged: {
                var listIndex = listViewElem.indexAt(contentX,contentY+listViewElem.headerItem.height);
                if (listIndex!==-1){currIndex = listIndex}
            }
        }
    }
}
