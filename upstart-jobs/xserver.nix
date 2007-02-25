{ stdenv, writeText

, lib

, xorgserver

, xinit

, # Initial client/window manager.
  twm, xterm

, # Needed for the display manager (SLiM).
  slim, xauth

, xf86inputkeyboard

, xf86inputmouse

, xf86videovesa

, # Virtual console for the X server.
  tty ? 7

, # X display number.
  display ? 0

, # List of font directories.
  fontDirectories

}:

let

  config = stdenv.mkDerivation {
    name = "xserver.conf";
    src = ./xserver.conf;
    inherit fontDirectories;
    buildCommand = "
      buildCommand= # urgh, don't substitute this
      export fontPaths=
      for i in $fontDirectories; do
        if test \"\${i:0:\${#NIX_STORE}}\" == \"$NIX_STORE\"; then
          for j in $(find $i -name fonts.dir); do
            fontPaths=\"\${fontPaths}FontPath \\\"$(dirname $j)\\\"\\n\"
          done
        fi
      done
      substituteAll $src $out
    ";
  };

  clientScript = writeText "xclient" "
    ${twm}/bin/twm &
    ${xterm}/bin/xterm -ls
  ";

  xserverArgs = [
    "-ac"
    "-nolisten tcp"
    "-terminate"
    "-logfile" "/var/log/X.${toString display}.log"
    "-modulepath" "${xorgserver}/lib/xorg/modules,${xf86inputkeyboard}/lib/xorg/modules/input,${xf86inputmouse}/lib/xorg/modules/input,${xf86videovesa}/lib/xorg/modules/drivers"
    "-config ${config}"
    ":${toString display}" "vt${toString tty}"
  ];

  # Note: lines must not be indented.
  slimConfig = writeText "slim.cfg" "
xauth_path ${xauth}/bin/xauth
default_xserver ${xorgserver}/bin/X
xserver_arguments ${toString xserverArgs}
login_cmd exec ${stdenv.bash}/bin/sh ${clientScript}
  ";

in

rec {
  name = "xserver";

  job = "
#start on network-interfaces

start script

end script

env SLIM_CFGFILE=${slimConfig}
env FONTCONFIG_FILE=/etc/fonts/fonts.conf # !!! cleanup

exec ${slim}/bin/slim
  ";
  
}
