#!/bin/bash

INSTDIR="${XDG_DATA_HOME-$HOME/.local/share}/multimc"


if [ `getconf LONG_BIT` = "64" ]
then
    PACKAGE="mmc-stable-lin64.tar.gz"
else
    PACKAGE="mmc-stable-lin32.tar.gz"
fi

deploy() {
    mkdir -p "$INSTDIR"
    cd "$INSTDIR"

    ${wget}/bin/wget --progress=dot:force "https://files.multimc.org/downloads/$PACKAGE" 2>&1 | \
        ${gnused}/bin/sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | \
        ${zenity}/bin/zenity --progress --auto-close --auto-kill --title="Downloading MultiMC..."

    ${gnutar}/bin/tar -xzf "$PACKAGE" --transform='s,MultiMC/,,'
    rm "$PACKAGE"
    chmod +x MultiMC
}

runmmc() {
    cd "$INSTDIR"
    # Force the run script to set the correct LD_LIBRARY_PATH for the launcher.
    export LAUNCHER_LIBRARY_PATH="/usr/lib"
    exec ./MultiMC "$@"
}

if [[ ! -f "$INSTDIR/MultiMC" ]]; then
    deploy
    runmmc "$@"
else
    runmmc "$@"
fi

