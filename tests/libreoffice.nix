{ runCommand, lib
, xdummy, xorg, ratpoison, fmbt
, libreoffice
, dbus, makeFontsConf, dejavu_fonts, carlito
}:
let
  dbusScript = ''
    mytmp="''${TMPDIR:-/tmp}/temporary-bus-$(id -u)/"
    mkdir -p "$mytmp"
    dbusdir="$(mktemp -d -p "$mytmp")"
    echo "$dbusdir" >&2
    cat "${dbus}/share/dbus-1/system.conf" | grep -v '[<]user[>]messagebus' > "$dbusdir/system.conf"
    "${dbus}"/bin/dbus-daemon --nopidfile --nofork --config-file "${dbus}"/share/dbus-1/session.conf --address "unix:path=$dbusdir/session"  >&2 &
    "${dbus}"/bin/dbus-daemon --nopidfile --nofork --config-file "$dbusdir/system.conf" --address "unix:path=$dbusdir/system" >&2 &
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$dbusdir/session"
    export DBUS_SYSTEM_BUS_ADDRESS="unix:path=$dbusdir/system"
  '';
  xdummyScript = ''
    export DISPLAY=":23"
    xdummy "$DISPLAY" &
    while ! xprop -root; do
      sleep 1;
    done

    xrandr --output default --mode 800x600
    xrandr --dpi 200
    echo Xft.dpi:200 | xrdb -
    xrdb -query

    ratpoison &
  '';
  fontconfigScript = ''
    export FONTCONFIG_FILE="${makeFontsConf {
      fontDirectories = [ dejavu_fonts carlito ];
    }}"
  '';
  fmbtHeader = ''
    import os
    import sys
    import fmbtx11
    import time

    screen = fmbtx11.Screen()
    screen.refreshScreenshot()

  '';
  fmbtScripts = {
    startSpreadsheet = ''
      if(not screen.verifyOcrText("File",match=1,area=[0.0, 0.0, 0.2, 0.2])):
        exit(1)
      screen.tapOcrText("File", area=[0.0, 0.0, 0.2, 0.2])
      if(not screen.waitOcrText("New",area=[0.0, 0.0, 0.2, 0.2])):
        exit(2)
      screen.tapOcrText("New", area=[0.0, 0.0, 0.2, 0.2])
      if(not screen.waitOcrText("Spreadsheet",area=[0.0, 0.0, 0.7, 0.2])):
        exit(3)
      screen.tapOcrText("Spreadsheet", area=[0.0, 0.0, 0.7, 0.2])
      time.sleep(1)
      screen.refreshScreenshot()
    '';
  };
in
runCommand "test-libreoffice" {
  buildInputs = [
    xorg.xprop xorg.xrandr xorg.xrdb xdummy ratpoison
    libreoffice dbus
    fmbt
    ];
  } ''
  set -x
  ${xdummyScript}
  ${dbusScript}
  ${fontconfigScript}

  export HOME="$PWD"
  soffice &

  while ! ratpoison -c "windows %c" | grep -i libreoffice; do
    sleep 1
  done

  fmbt-python -c '${fmbtHeader}${fmbtScripts.startSpreadsheet}'
  ratpoison -c windows | grep "Calc"

  mkdir -p "$out"/share/
  cp -r screenshots "$out/share"
  exit 0
''
