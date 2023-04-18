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
                            visible: index === listViewElem.listIndex && listViewElem.headerItem.userInput === ""
                            color :"#01a884"
                        }
                    }
                }
            }
        }

        ListView {
            id: listViewElem
            anchors { top: row.bottom; bottom: parent.bottom; left: parent.left; right: parent.right; bottomMargin: 20 }
            property int listIndex
            model: myModel.jsModel
            preferredHighlightBegin: 0
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
                spacing: 10
                leftPadding: 20; rightPadding: 20; topPadding: emojisFlow.visible*10
                Text {
                    text: modelData.category
                    font { pixelSize: 14; weight: Font.DemiBold } color: "#798287"
                    visible: emojisFlow.visible
                }
                Flow {
                    id: emojisFlow
                    width: listViewElem.width - (parent.leftPadding + parent.rightPadding)
                    visible: height
                    spacing: 20
                    Repeater {
                        model: listViewElem.headerItem.userInput!=="" ? modelData.emojis.filter(elem => elem.description.includes(listViewElem.headerItem.userInput)) : modelData.emojis
                        delegate: Text {text: modelData.emoji; font.pixelSize: 30}
                    }
                }
            }
            onContentYChanged: {
                var viewIndex = listViewElem.indexAt(contentX,contentY+listViewElem.headerItem.height);
                if (viewIndex!==-1){listIndex = viewIndex}
            }
        }
    }
}
