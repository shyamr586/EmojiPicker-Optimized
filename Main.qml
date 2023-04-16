import QtQuick
import QtQuick.Window

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Model {id: myModel}
    property var filteredModel: [];

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

                Item {
                    height: 50; width: parent.width/myModel.jsModel.length;
                    Text {anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 20}
                    Rectangle {
                        id: highlight
                        anchors.bottom: parent.bottom
                        height: 4; width: parent.width
                        visible: index === listViewElem.currentIndex
                        color :"#01a884"

                    }
                    MouseArea {anchors.fill: parent; onClicked: {listViewElem.currentIndex = index; console.log("Highlighted index: ",index)}}
                }
            }
        }

        ListView {
            id: listViewElem
            //property int currIndex: 0
            anchors {top: row.bottom; bottom: parent.bottom; left: parent.left; right: parent.right; bottomMargin: 20 }
            model: myModel.jsModel
            spacing: 10
            preferredHighlightBegin: 0
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 100
            property bool categoryVisible: true
            header: Rectangle {
                anchors { left: parent.left; right: parent.right; margins: 10}
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
                    //onTextChanged: if text!=="";
                    Text {text: "Search Emoji"; color: "#798186"; z:-1; leftPadding: parent.leftPadding; visible: !parent.text; font.pixelSize: 15}}
            }
            headerPositioning: ListView.OverlayHeader
            clip: true
            delegate: Column{
                spacing: 20
                leftPadding: 20; rightPadding: 20
                Text {visible: listViewElem.categoryVisible; text: modelData.category; color: "#798287"; font.pixelSize: 14; font.weight: Font.DemiBold; topPadding: 20}
                Flow {
                    width: listViewElem.width - (parent.leftPadding + parent.rightPadding)
                    spacing: 20
                    anchors.leftMargin: 10
                    Repeater{
                        model: listViewElem.headerItem.userInput!=="" ?
                                   modelData.emojis.filter(elem => elem.description.includes(listViewElem.headerItem.userInput)) : modelData.emojis
                        delegate: Rectangle {
                            height: 30; width: 30;
                            color: "transparent";
                            Text {text: modelData.emoji; anchors.centerIn: parent; font.pixelSize: 30;}}
                    }
                }
            }
            onCurrentIndexChanged: console.log("Listview curr index: ",currentIndex)
            //onContentYChanged: if (indexAt(x,contentY)!==-1){currIndex = indexAt(x,contentY)}

        }

    }

    function filterEmojiList(searchText) {
        listViewElem.categoryVisible = (searchText === "");

        if (searchText !== "") {
            var filteredEmojiList = myModel.jsModel.flatMap(function(category) {
                return category.emojis.filter(function(emoji) {
                    return emoji.description.toLowerCase().indexOf(searchText.toLowerCase()) !== -1;
                });
            });

            listViewElem.model = filteredEmojiList;
        } else {
            listViewElem.model = myModel.jsModel;
        }
    }

}
