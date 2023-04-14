import QtQuick
import QtQuick.Window

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Model {id: jsModel}

    Rectangle {
        anchors {left: parent.left; right: parent.right; bottom: parent.bottom;}
        color: "#202c32"
        height: 345;

        Component {
            id: highlightComponent

            Rectangle {
                id: parentHighlightRect
                color: "transparent"
                Rectangle {
                    id: highlightedRect
                    color: "#01a884"
                    anchors.bottom: parentHighlightRect.bottom
                    height: 4
                    width: parentHighlightRect.width
                }
            }
        }
        //CORRECTION: KEEP THIS^ AS A ONE LINE IN THE LISTVIEW (IF YOURE USING LISTVIEW)

        ListView {
            id: tabs
            width: parent.width
            anchors { top: parent.top; left: parent.left; right: parent.right}
            height: 40
            interactive: false
            orientation: ListView.Horizontal
            model: jsModel
            highlightFollowsCurrentItem : true
            highlight: isSearch ? null : highlightComponent //CORRECTION: Instead of this, use isSearch to set the visible as true or false
            highlightMoveDuration: 100
            delegate: Rectangle {
                id: parent
                width: tabs.width/8; height: 40; color: "transparent"
                Text { anchors.centerIn: parent; text: jsModel[index].icon; font.pixelSize: 20}
                MouseArea { anchors.fill: parent; onClicked: emojiListView.currentIndex = index}
            }
        }

        Rectangle {
            id: searchbarwrapper
            width: parent.width
            height: 60
            color: "transparent"
            anchors {top: tabs.bottom; left: parent.left; right: parent.right}

            state: "default"

            //CORRECTION: Again dont use states and stuff for this, javascript is fine.
            states:[
                State {
                    name: "default"
                    PropertyChanges { target: searchbarwrapper; visible: true }
                    PropertyChanges { target: searchbarwrapper; height: searchbarheight }
                },
                State {
                    name: "hidden"
                    PropertyChanges { target: searchbarwrapper; height: 0 }     //CORRECTION: Instead of height, change y.
                    PropertyChanges { target: searchbarwrapper; visible: false }
                }]

            //CORRECTION: Make this a one liner
            Behavior on height { NumberAnimation { duration: 200 } }

            //CORRECTION: Make this work on like the listview's header instead of a rectangle like this.
            Rectangle {
                id: emojisearchbar
                anchors.fill: parent
                anchors.margins: 10
                radius: 5
                color: "#232d35"

                TextInput {
                    id: searchInput
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    leftPadding: 5
                    font.pixelSize: 15
                    color: "white"
                    state: "default"
                    focus: false

                    //CORRECTION: States and default states thing again.

                    states: [
                        State {
                            name: "default"; when: searchInput.text===""
                            PropertyChanges { target: placeholder; text: "Search Emoji" }
                            PropertyChanges { target: placeholder; color: "#798186" }
                            PropertyChanges { target: emojiListView; visible: true }
                            PropertyChanges { target: searchResults; visible: false }
                        },
                        State {
                            name: "typed"; when: searchInput.text!==""
                            PropertyChanges { target: placeholder; text: "" }
                            PropertyChanges { target: emojiListView; visible: false }
                            PropertyChanges { target: searchResults; visible: true }
                        }
                    ]

                    //CORRECTION: Instead of this, you can put the preedittext on the 'when' of states, just use ||
//                    onPreeditTextChanged: {
//                        if(preeditText!==""){
//                            state = "typed"
//                        } else {
//                            state = "default"
//                        }
//                    }

                    Text {
                        id: placeholder
                        text: "Search Emoji"
                        leftPadding: 5
                        color: "#798186"
                        z: -1
                        visible: !searchInput.text
                        font.pixelSize: 15
                    }

                    onTextChanged: {
                        if (text!==""){
                            var filteredValues = getFilteredData(text);
                            if (filteredValues.length !== 0){
                                isSearch = true
                                searchResultsArray = filteredValues
                            }
                        }
                        else {
                            isSearch = false
                        }
                    }
                }

            }
        }

        ListView {
            id: emojiListView
            anchors.top: searchbarwrapper.bottom
            height: parent.height - (searchbarwrapper.height/2); width: parent.width
            clip: true
            model: jsModel
            anchors.left: parent.left
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 10000
            //
            delegate:
                //CORRECTION: Use Columns so that the spacing is alright rather than using implicit height
                Column {
                //id: column //CORRECTION: Dont put an id that is not being used
                // CORRECTION: DONT USE IMPLICIT HEIGHT
                width: parent.width //CORECTION: use parent.width instead
                Text {id: categoryText; text: jsModel[index].category; color: "#798287"; leftPadding: 10; topPadding: 15; opacity: 0.7; font.pixelSize: 14; font.weight: Font.DemiBold}
                Flow {
                    id: flowElem
                    width: column.width
                    padding: 10
                    //anchors.top: categoryText.bottom
                    spacing: 3
                    Repeater {
                        model: values
                        delegate: Rectangle {
                            height: emojiText.implicitHeight; width: emojiText.implicitWidth
                            color: "transparent"
                            Text {id: emojiText; text: value; anchors.centerIn: parent; font.pixelSize: 33;}
                            MouseArea {anchors.fill: parent; onClicked: inputText.text+=value}
                        }
                    }
                }
            }

            preferredHighlightBegin: 0
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 100
            property int previousContentY: 0
            property string scrolledDirection: ""

            onContentYChanged: {
                tabs.currentIndex = indexAt(contentX,contentY); //CORRECTION: Can make it a one liner
            }

            //CORRECTION, not the way to make the search bar disappear, have to check out 'headers' for listview and check its properties, might have a scrolling detected or something
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onWheel: {
                    if (wheel.angleDelta.y > 0) {
                        searchbarwrapper.state = "default"
                    } else if (wheel.angleDelta.y < 0) {
                        searchbarwrapper.state = "hidden"
                    }
                    wheel.accepted = false
                }
            }

        }

        //CORRECTION: Search results shouldnt be a separate array/model, filter the original array
        Flow {
            id: searchResults
            anchors.top: searchbarwrapper.bottom
            height: parent.height - (inputField.height + searchbarwrapper.height/2); width: parent.width
            clip: true
            visible: false
            Repeater {
                id: searchRepeater
                model: searchResultsArray
                delegate: Rectangle {
                    height: 60; width: 60
                    color: "transparent"
                    Text {id: searchedEmojiText; text: searchResultsArray[index]; anchors.centerIn: parent; font.pixelSize: 30;}
                }
            }
        }

    }
}
