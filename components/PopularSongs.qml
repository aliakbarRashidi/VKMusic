import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Content 0.1
import Ubuntu.Components.Popups 1.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/scripts.js" as Scripts

Item {
    id: popularsongs

    property var offset : 0

    function get_popular() {
        Scripts.popular_songs(offset);
    }

    ListModel {
        id: popularSongsModel
    }

    ListView {
        id:popularSongsList
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        property var status : 0

        model:popularSongsModel
        delegate: ListItem.Empty {
            id: itemsDelegate

            width: parent.width
            height: itemtitle.height + units.gu(4)

            Item {
                id: delegateitem
                anchors.fill: parent
                visible: off == 1 ? false : true
                Text {
                    anchors.top: parent.top
                    anchors.topMargin: units.gu(1)
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(1)
                    width: parent.width
                    id: itemtitle
                    text: title
                    color: playing_song == id ? '#2B587A' : UbuntuColors.darkGrey
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    font.pointSize: playing_song == id ? units.gu(1.8) : units.gu(1.6)
                }
                Text {
                    anchors.top: itemtitle.bottom
                    anchors.topMargin: units.gu(0)
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(1)
                    width: parent.width
                    id: itemartist
                    text: artist
                    color: UbuntuColors.darkGrey
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    font.pointSize: units.gu(1.2)
                }
            }
            Item {
                id: offitem
                anchors.fill: parent
                visible: off == 1 ? true : false
                Button {
                    anchors.centerIn: parent
                    text: i18n.tr("Load more")
                    onClicked: {
                        popularpage.offset = popularpage.offset + 100;
                        get_popular();
                    }
                }
            }
            onClicked: {
                if (off != 1) {
                    queueModel.clear();
                    for (var i = 0; i < popularSongsModel.count; i++) {
                        queueModel.append(popularSongsModel.get(i));
                    }
                    current_song_index = index;
                    Scripts.play_song(id, title, artist, songImage, songURL);
                }
            }
        }
        PullToRefresh {
            refreshing: popularSongsModel.count == 0 && popularSongsList.status == 0
            onRefresh: {
                offset = 0;
                get_popular()
            }
        }
    }

    Item {
        id: indicat
        anchors.centerIn: parent
        opacity: popularSongsModel.count == 0 && popularSongsList.status == 0 ? 1 : 0

        Behavior on opacity {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.SlowDuration
            }
        }

        ActivityIndicator {
            id: activity
            running: true
        }
    }
}
