{ genericSubstituter

, xorgserver

, xf86inputkeyboard

, xf86inputmouse

, xf86videovesa

, # Virtual console for the X server.
  tty ? 7

, # X display number.
  display ? 0

}:

let

  config = genericSubstituter {
    name = "xserver.conf";
    src = ./xserver.conf;
  };

in

rec {
  name = "xserver";

  job = "
start on network-interfaces

start script

end script

# !!! -ac is a bad idea.
exec ${xorgserver}/bin/X \\
    -ac -nolisten tcp -terminate \\
    -logfile /var/log/X.${toString display}.log \\
    -fp /var/fonts \\
    -modulepath ${xorgserver}/lib/xorg/modules,${xf86inputkeyboard}/lib/xorg/modules/input,${xf86inputmouse}/lib/xorg/modules/input,${xf86videovesa}/lib/xorg/modules/drivers \\
    -config ${config} \\
    :${toString display} vt${toString tty}

  ";
  
}
