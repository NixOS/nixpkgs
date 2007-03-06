{ stdenv, writeText, lib, xorg, mesa, xterm, slim, gnome
, compiz, feh

, config

, # Virtual console for the X server.
  tty ? 7

, # X display number.
  display ? 0

, # List of font directories.
  fontDirectories

}:

let

  getCfg = option: config.get ["services" "xserver" option];

  optional = condition: x: if condition then [x] else [];


  # Get a bunch of user settings.
  videoDriver = getCfg "videoDriver";
  resolutions = map (res: "\"${toString res.x}x${toString res.y}\"") (getCfg "resolutions");
  windowManager = getCfg "windowManager";
  sessionType = getCfg "sessionType";
  sessionStarter = getCfg "sessionStarter";


  sessionCmd =
    if sessionType == "" then sessionStarter else
    if sessionType == "xterm" then "${xterm}/bin/xterm -ls" else
    if sessionType == "gnome" then "${gnome.gnometerminal}/bin/gnome-terminal" else
    abort ("unknown session type "+ sessionType);


  modules = [
    xorg.xorgserver
    xorg.xf86inputkeyboard
    xorg.xf86inputmouse
  ] 
  ++ optional (videoDriver == "vesa") xorg.xf86videovesa
  ++ optional (videoDriver == "i810") xorg.xf86videoi810;


  configFile = stdenv.mkDerivation {
    name = "xserver.conf";
    src = ./xserver.conf;
    inherit fontDirectories videoDriver resolutions;
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

      export modulePaths=
      for i in $(find ${toString modules} -type d); do
        if ls $i/*.so 2> /dev/null; then
          modulePaths=\"\${modulePaths}ModulePath \\\"$i\\\"\\n\"
        fi
      done

      substituteAll $src $out
    ";
  };


  clientScript = writeText "xclient" "

    exec > $HOME/.Xerrors 2>&1
  

    ### Start a window manager.
  
    ${if windowManager == "twm" then "
    ${xorg.twm}/bin/twm &
    "

    else if windowManager == "metacity" then "
    # !!! Hack: load the schemas for Metacity.
    GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \\
      --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas
    ${gnome.metacity}/bin/metacity &
    "

    else if windowManager == "compiz" then "
    
    # !!! Hack: load the schemas for Compiz.
    GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \\
      --makefile-install-rule ${compiz}/etc/gconf/schemas/*.schemas

    # !!! Hack: turn on most Compiz modules.
    ${gnome.GConf}/bin/gconftool-2 -t list --list-type=string \\
      --set /apps/compiz/general/allscreens/options/active_plugins \\
      [gconf,png,decoration,wobbly,fade,minimize,move,resize,cube,switcher,rotate,place,scale,water,zoom]

    # Start Compiz and the GTK-style window decorator.
    ${compiz}/bin/compiz gconf &
    ${compiz}/bin/gtk-window-decorator &
    "

    else abort ("unknown window manager "+ windowManager)}


    ### Show a background image.
    if test -e $HOME/.background-image; then
      ${feh}/bin/feh --bg-scale $HOME/.background-image
    fi
    

    ### Start a 'session' (right now, this is just a terminal).
    # !!! yes, this means that you 'log out' by killing the X server.
    while ${sessionCmd}; do
      sleep 1  
    done
  "; # */ <- hack to fix syntax highlighting


  xserverArgs = [
    "-ac"
    "-nolisten tcp"
    "-terminate"
    "-logfile" "/var/log/X.${toString display}.log"
    "-config ${configFile}"
    ":${toString display}" "vt${toString tty}"
  ];

  
  # Note: lines must not be indented.
  slimConfig = writeText "slim.cfg" "
xauth_path ${xorg.xauth}/bin/xauth
default_xserver ${xorg.xorgserver}/bin/X
xserver_arguments ${toString xserverArgs}
login_cmd exec ${stdenv.bash}/bin/sh ${clientScript}
  ";


in


rec {
  name = "xserver";

  
  extraPath = [
    xorg.xrandr
    feh
  ]
  ++ optional (windowManager == "twm") [
    xorg.twm
  ]
  ++ optional (windowManager == "metacity") [
    gnome.metacity
  ]
  ++ optional (windowManager == "compiz") [
    compiz
  ]
  ++ optional (sessionType == "xterm") [
    xterm
  ]
  ++ optional (sessionType == "gnome") [
    gnome.gnometerminal
    gnome.GConf
    gnome.gconfeditor
  ];

    
  job = "
    #start on network-interfaces

    start script
      rm -f /var/state/opengl-driver
      ${if getCfg "driSupport"
        then "ln -sf ${mesa} /var/state/opengl-driver"
        else ""
      }
    end script

    env SLIM_CFGFILE=${slimConfig}
    env FONTCONFIG_FILE=/etc/fonts/fonts.conf # !!! cleanup

    ${if getCfg "driSupport"
      then "env XORG_DRI_DRIVER_PATH=${mesa}/lib/modules/dri"
      else ""
    }

    exec ${slim}/bin/slim
  ";
  
}
