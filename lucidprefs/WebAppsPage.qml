import QtQuick
import Quickshell.Io
import qs

Column {
    id: page

    spacing: 26

    // Reads the list of installed web apps by running: webapp list-raw
    ListModel {
        id: appsModel
    }

    function refresh() {
        appsModel.clear();
        listProc.running = true;
    }

    Process {
        id: listProc

        command: ["webapp", "list-raw"]

        stdout: SplitParser {
            onRead: (line) => {
                if (line.indexOf("|") === -1)
                    return;
                var parts = line.split("|");
                appsModel.append({ "name": parts[0], "url": parts[1] || "" });
            }
        }
    }

    Process {
        id: installProc

        onRunningChanged: {
            if (!installProc.running)
                page.refresh();
        }
    }

    Process {
        id: removeProc

        onRunningChanged: {
            if (!removeProc.running)
                page.refresh();
        }
    }

    Component.onCompleted: page.refresh()

    SettingCard {
        title: "ADD A WEB APP"

        SettingRow {
            title: "Name"
            description: "What it's called in the launcher and dock."
            stacked: true

            M3TextField {
                id: nameField

                width: parent.width
                placeholder: "e.g. YouTube"
                onEdited: (v) => nameField.text = v
            }

        }

        SettingRow {
            title: "Website"
            description: "The page it opens, without needing https:// in front."
            stacked: true

            M3TextField {
                id: urlField

                width: parent.width
                placeholder: "e.g. youtube.com"
                onEdited: (v) => urlField.text = v
            }

        }

        SettingRow {
            title: "Icon (optional)"
            description: "A link to an image, or leave blank to use the site's own favicon automatically."
            showDivider: false
            stacked: true

            M3TextField {
                id: iconField

                width: parent.width
                placeholder: "e.g. https://example.com/icon.png"
                onEdited: (v) => iconField.text = v
            }

        }

        SettingRow {
            title: "Install"
            description: "Adds it to the launcher and dock, opening in its own window."
            showDivider: false

            M3Button {
                text: "Install"
                variant: "filled"
                enabled: nameField.text !== "" && urlField.text !== ""
                onClicked: {
                    var args = ["webapp", "install", nameField.text, urlField.text];
                    if (iconField.text !== "")
                        args.push(iconField.text);
                    installProc.command = args;
                    installProc.running = true;
                    nameField.clear();
                    urlField.clear();
                    iconField.clear();
                }
            }

        }

    }

    SettingCard {
        title: "INSTALLED WEB APPS"

        Repeater {
            model: appsModel

            SettingRow {
                required property string name
                required property int index

                title: name
                showDivider: index !== appsModel.count - 1

                M3Button {
                    text: "Remove"
                    variant: "text"
                    destructive: true
                    onClicked: {
                        removeProc.command = ["webapp", "remove", name];
                        removeProc.running = true;
                    }
                }

            }

        }

    }

}
