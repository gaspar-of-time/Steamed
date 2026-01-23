/*This has mostly been reworked from Reactionary but
 * I'm not sure if I've changed enough for it to be
 * considered original. You know the Ship of Theseus
 * thought experiment.
*/

import "."
import QtCore
import QtQuick
import QtQuick.Controls
import SddmComponents 2.0
import "."

Rectangle {
    id: container

    property int sessionIndex: session.index

    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    Component.onCompleted: {
        nameinput.focus = true;
    }

    TextConstants {
        id: textConstants
    }

    Connections {
        // errorMessage.text = textConstants.loginSucceeded;

        function onLoginSucceeded() {
        }

        function onLoginFailed() {
            password.text = "";
            errorMessage.color = "#ff3333";
            errorMessage.text = textConstants.loginFailed;
        }

        target: sddm
    }

    FontLoader {
        id: myfontNormal

        source: "assets/WineTahomaBit.ttf"
    }

    Image {
        id: behind

        anchors.fill: parent
        source: config.background
        fillMode: Image.Stretch
        onStatusChanged: {
            if (config.type === "color")
                source = config.defaultBackground;

        }
    }

    Image {
        id: promptBox

        anchors.centerIn: parent
        source: "assets/promptbox.svg"
        width: 360
        height: 260

        Text {
            id: productName

            font.family: myfontNormal.name
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 26
            color: "#f1f2f0"
            text: textConstants.login + " - " + sddm.hostName
            font.pixelSize: 11
        }

        Image {
            id: imageinput

            source: "assets/input.svg"
            y: 46
            anchors.right: parent.right
            anchors.rightMargin: 26
            width: 222
            height: 24

            TextField {
                id: nameinput

                font.family: myfontNormal.name
                focus: true
                anchors.fill: parent
                text: userModel.lastUser
                font.pixelSize: 11
                leftPadding: 8
                topPadding: 0
                bottomPadding: 0
                color: "#f1f2f0"
                selectByMouse: true
                selectionColor: "#958831"
                selectedTextColor: "#f4f4ff"
                KeyNavigation.tab: password
                KeyNavigation.backtab: password
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                        password.focus = true;

                }
                onActiveFocusChanged: {
                    if (activeFocus)
                        userlabel.color = "#c4b550";
                    else
                        userlabel.color = "#f4f4f4";
                }

                background: Image {
                    id: textback

                    source: "assets/input.svg"
                }

            }
            //inputimage

        }

        Image {
            id: imagepassword

            source: "assets/input.svg"
            anchors.top: imageinput.bottom
            anchors.horizontalCenter: imageinput.horizontalCenter
            anchors.topMargin: 8
            width: 222
            height: 24

            TextField {
                id: password

                font.family: myfontNormal.name
                anchors.fill: parent
                font.pixelSize: 11
                leftPadding: 8
                topPadding: 0
                bottomPadding: 0
                echoMode: TextInput.Password
                color: "#f1f2f0"
                selectionColor: "#958831"
                selectedTextColor: "#f4f4ff"
                KeyNavigation.tab: nameinput
                KeyNavigation.backtab: nameinput
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(nameinput.text, password.text, sessionIndex);
                        event.accepted = true;
                    }
                }
                onActiveFocusChanged: {
                    if (activeFocus)
                        passwordlabel.color = "#c4b550";
                    else
                        passwordlabel.color = "#f4f4f4";
                }

                background: Image {
                    id: textback1

                    source: "assets/input.svg"
                }

            }

        }

        Text {
            id: userlabel

            anchors.right: imageinput.left
            anchors.verticalCenter: imageinput.verticalCenter
            anchors.rightMargin: 8
            font.family: myfontNormal.name
            font.pixelSize: 11
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: 28
            text: textConstants.userName
            color: "#f1f2f0"
        }

        Text {
            id: passwordlabel

            anchors.right: imagepassword.left
            anchors.bottom: imagepassword.bottom
            anchors.verticalCenter: imagepassword.verticalCenter
            anchors.rightMargin: 8
            font.family: myfontNormal.name
            font.pixelSize: 11
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: 28
            text: textConstants.password
            color: "#f1f2f0"
        }

        Image {
            id: loginButton

            anchors.left: imagepassword.left
            anchors.top: imagepassword.bottom
            anchors.topMargin: 8
            width: 78
            height: 24
            source: "assets/buttonup.svg"

            MouseArea {
                id: ma3

                anchors.fill: parent
                onPressed: parent.source = "assets/buttondown.svg"
                onReleased: {
                    parent.source = "assets/buttonup.svg";
                    sddm.login(nameinput.text, password.text, sessionIndex);
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 6
                color: "#f1f2f0"
                font.family: myfontNormal.name
                font.pixelSize: 11
                text: textConstants.login
            }

        }

        Image {
            id: cancelButton

            anchors.verticalCenter: loginButton.verticalCenter
            anchors.left: loginButton.right
            anchors.leftMargin: 6
            width: 78
            height: 24
            source: "assets/buttonup.svg"

            MouseArea {
                id: ma4

                anchors.fill: parent
                onPressed: parent.source = "assets/buttondown.svg"
                onReleased: {
                    parent.source = "assets/buttonup.svg";
                    sddm.powerOff();
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 6
                color: "#f1f2f0"
                font.family: myfontNormal.name
                font.pixelSize: 11
                text: textConstants.shutdown
            }

        }

        Image {
            id: showPasswordButton

            anchors.left: loginButton.left
            anchors.top: loginButton.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 12
            width: 12
            height: 12
            source: "assets/checkbox.svg"

            Image {
                id: passwordCheck

                anchors.fill: parent
                anchors.margins: -2
                source: "assets/checked.svg"
            }

            MouseArea {
                id: ma5

                property bool isToggled: false

                anchors.fill: parent
                state: "noShowPass"
                onReleased: {
                    ma5.isToggled = !ma5.isToggled;
                    if (isToggled)
                        state = "showPass";
                    else
                        state = "noShowPass";
                }
                states: [
                    State {
                        name: "noShowPass"

                        PropertyChanges {
                            target: password
                            echoMode: TextInput.Password
                        }

                        PropertyChanges {
                            target: passwordCheck
                            opacity: 0
                        }

                    },
                    State {
                        name: "showPass"

                        PropertyChanges {
                            target: password
                            echoMode: TextInput.Normal
                        }

                        PropertyChanges {
                            target: passwordCheck
                            opacity: 1
                        }

                    }
                ]
            }

            Text {
                id: showpasswordlabel

                anchors.left: showPasswordButton.right
                anchors.verticalCenter: showPasswordButton.verticalCenter
                anchors.leftMargin: 8
                anchors.alignWhenCentered: false
                font.family: myfontNormal.name
                font.pixelSize: 11
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                height: 11
                text: textConstants.showPasswordPrompt
                color: "#f1f2f0"
            }

        }

        Image {
            id: resetpass

            anchors.right: promptBox.right
            anchors.bottom: promptBox.bottom
            anchors.bottomMargin: 26
            anchors.rightMargin: 26
            width: 142
            height: 24
            source: "assets/widebuttonup.svg"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: false
                onPressed: parent.source = "assets/widebuttondown.svg"
                onReleased: {
                    sddm.reboot();
                    parent.source = "assets/widebuttonup.svg";
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 6
                color: "#f1f2f0"
                font.family: myfontNormal.name
                font.pixelSize: 11
                text: textConstants.reboot + " computer..."
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                anchors.rightMargin: 6
                color: "#9fa994"
                font.family: myfontNormal.name
                font.pixelSize: 11
                text: "Restart your computer?"
            }

        }

        ComboBox {
            id: session

            anchors.horizontalCenter: resetpass.horizontalCenter
            anchors.bottom: resetpass.top
            anchors.bottomMargin: 7
            width: 142
            height: 24
            font.pixelSize: 11
            font.family: myfontNormal.name
            model: sessionModel
            index: sessionModel.lastIndex
            borderColor: "#32392c"
            color: "#f1f2f0"
            menuColor: "#3e4637"
            textColor: "#f1f2f0"
            hoverColor: "#958831"
            focusColor: "#595959"
            arrowBox: "assets/comboarrow.svg"
            backgroundNormal: "assets/cbox.svg"
            backgroundHover: "assets/cboxhover.svg"
            backgroundPressed: "assets/cbox.svg"
            KeyNavigation.backtab: password
            KeyNavigation.tab: nameinput

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                anchors.rightMargin: 6
                color: "#9fa994"
                font.family: myfontNormal.name
                font.pixelSize: 11
                text: "Change your session?"
            }

        }

        Text {
            id: errorMessage

            font.family: myfontNormal.name
            anchors.bottom: imageinput.top
            anchors.horizontalCenter: promptBox.horizontalCenter
            anchors.bottomMargin: 4
            color: "#f1f2f0"
            text: ""
            font.pixelSize: 11
        }

    }

}