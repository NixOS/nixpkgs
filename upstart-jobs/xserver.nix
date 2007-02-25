{ stdenv

, lib

, xorgserver

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

in

rec {
  name = "xserver";

  job = "
#start on network-interfaces

start script

end script

# !!! -ac is a bad idea.
exec ${xorgserver}/bin/X \\
    -ac -nolisten tcp -terminate \\
    -logfile /var/log/X.${toString display}.log \\
    -modulepath ${xorgserver}/lib/xorg/modules,${xf86inputkeyboard}/lib/xorg/modules/input,${xf86inputmouse}/lib/xorg/modules/input,${xf86videovesa}/lib/xorg/modules/drivers \\
    -config ${config} \\
    :${toString display} vt${toString tty}
  ";
  
}
