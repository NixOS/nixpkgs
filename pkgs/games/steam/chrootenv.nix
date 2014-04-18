{ buildFHSChrootEnv, steam
, xterm, libX11, zenity, python, mesa, xdg_utils, dbus_tools, alsaLib, su
}:

buildFHSChrootEnv {
  name = "steam";
  pkgs = [ steam xterm libX11 zenity python mesa xdg_utils dbus_tools alsaLib su ];
  profile = ''
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib:/lib
    export FONTCONFIG_FILE=/etc/fonts/fonts.conf
  '';
}
