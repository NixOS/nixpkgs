{ stdenv, writeText, lib, xorg, mesa, xterm, slim, gnome
, compiz, feh
, kdelibs, kdebase
, xkeyboard_config
, openssh, x11_ssh_askpass
, nvidiaDrivers, libX11, libXext
, synaptics

, config

, # Virtual console for the X server.
  tty ? 7

, # X display number.
  display ? 0

, # List of font directories.
  fontDirectories

, # Is Clone mode on?
  isClone ? "on"

, # Do we want it to run or just to prepare everything?
  autorun ? true

, # Create unneeded links in /etc? 
  exportConfiguration ? false
}:

let

  cfg = config.services.xserver;

  optional = condition: x: if condition then [x] else [];

  # Get a bunch of user settings.
  videoDriver = cfg.videoDriver;
  resolutions = map (res: ''"${toString res.x}x${toString res.y}"'') (cfg.resolutions);
  sessionType = cfg.sessionType;
  sessionStarter = cfg.sessionStarter;
  renderingFlag = cfg.renderingFlag;


  sessionCmd =
    if sessionType == "" then sessionStarter else
    if sessionType == "xterm" then "${xterm}/bin/xterm -ls" else
    if sessionType == "gnome" then "${gnome.gnometerminal}/bin/gnome-terminal -ls" else
    abort ("unknown session type "+ sessionType);


  windowManager =
    let wm = cfg.windowManager; in
    if wm != "" then wm else
    if sessionType == "gnome" then "metacity" else
    if sessionType == "kde" then "none" /* started by startkde */ else
    "twm";

    
  modules = 
    optional (videoDriver == "nvidia") nvidiaDrivers ++       #make sure it first loads the nvidia libs
    [
      xorg.xorgserver
      xorg.xf86inputkeyboard
      xorg.xf86inputmouse
    ] 
    ++ optional (videoDriver == "vesa") xorg.xf86videovesa
    ++ optional (videoDriver == "vga") xorg.xf86videovga
    ++ optional (videoDriver == "sis") xorg.xf86videosis
    ++ optional (videoDriver == "i810") xorg.xf86videoi810
    ++ optional (videoDriver == "intel") xorg.xf86videointel
    ++ optional (videoDriver == "nv") xorg.xf86videonv
    ++ optional (videoDriver == "ati") xorg.xf86videoati
    ++ (optional (cfg.isSynaptics) [(synaptics+"/"+xorg.xorgserver) /*xorg.xf86inputevdev*/]);

        
  configFile = stdenv.mkDerivation {
    name = "xserver.conf";
    src = ./xserver.conf;
    inherit fontDirectories videoDriver resolutions isClone;

    synapticsInputDevice = if cfg.isSynaptics then ''
      Section "InputDevice"
        Identifier "Touchpad[0]"
        Driver "synaptics"
        Option "Device" "${cfg.devSynaptics}"
        Option "Protocol" "PS/2"
        Option "LeftEdge" "1700"
        Option "RightEdge" "5300"
        Option "TopEdge" "1700"
        Option "BottomEdge" "4200"
        Option "FingerLow" "25"
        Option "FingerHigh" "30"
        Option "MaxTapTime" "180"
        Option "MaxTapMove" "220"
        Option "VertScrollDelta" "100"
        Option "MinSpeed" "0.06"
        Option "MaxSpeed" "0.12"
        Option "AccelFactor" "0.0010"
        Option "SHMConfig" "on"
        Option "Repeater" "/dev/input/mice"
        Option "TapButton1" "1"
        Option "TapButton2" "2"
        Option "TapButton3" "3"
      EndSection
    '' else "";

    xkbOptions = if cfg.xkbOptions == "" then "" else  ''
      Option "XkbOptions" "${cfg.xkbOptions}"
    '';

    layout = cfg.layout;

    corePointer = if cfg.isSynaptics then "Touchpad[0]" else "Mouse[0]";

    internalAGPGART =
      if cfg.useInternalAGPGART == "yes" then
        ''  Option "UseInternalAGPGART" "yes"''
      else if cfg.useInternalAGPGART == "no" then
	''  Option "UseInternalAGPGART" "no"''
      else "";

    extraDeviceConfig = cfg.extraDeviceConfig; 
    extraMonitorSettings = cfg.extraMonitorSettings; 
    extraDisplaySettings = cfg.extraDisplaySettings;
    extraModules = cfg.extraModules; 
    serverLayoutOptions = cfg.serverLayoutOptions; 
    defaultDepth = cfg.defaultDepth; 

    xfs = if cfg.useXFS == false then "" else 
      ''FontPath "${toString cfg.useXFS}"'';

    buildCommand = ''
      buildCommand= # urgh, don't substitute this

      export fontPaths=
      for i in $fontDirectories; do
        if test "''${i:0:''${#NIX_STORE}}" == "$NIX_STORE"; then
          for j in $(find $i -name fonts.dir); do
            fontPaths="''${fontPaths}FontPath \"$(dirname $j)\"''\n"
          done
        fi
      done

      export modulePaths=
      for i in $(find ${toString modules} -type d); do
        if ls $i/*.so 2> /dev/null; then
          modulePaths="''${modulePaths}ModulePath \"$i\"''\n"
        fi
      done

      #if only my gf were this dirty
      if test "${toString videoDriver}" == "nvidia"; then
        export moduleSection='
          Load "glx"
          SubSection "extmod"
            Option "omit xfree86-dga"
          EndSubSection
        '

        export screen='
          Option "AddARGBGLXVisuals" "true"
          Option "DisableGLXRootClipping" "true"
        '
        
        export device='
          Option "RenderAccel" "true"
          Option "AllowGLXWithComposite" "true"
          Option "AddARGBGLXVisuals" "true"
        '
        
        export extensions='
          Option "Composite" "Enable"
        '

      else
        export moduleSection='
          Load "glx"
          Load "dri"
        '
        export screen=
        export device=
        export extensions=
      fi
	
      if [ "${toString videoDriver}" = i810 ]; then
        export extensions='
          Option "Composite" "Enable"
        ';
      fi;

      substituteAll $src $out
    '';
  };


  clientScript = writeText "xclient" ''

    source /etc/profile

    exec > $HOME/.Xerrors 2>&1


    ### Load X defaults.
    if test -e ~/.Xdefaults; then
      ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
    fi


    ${if cfg.startSSHAgent then ''
      ### Start the SSH agent.
      export SSH_ASKPASS=${x11_ssh_askpass}/libexec/x11-ssh-askpass
      eval $(${openssh}/bin/ssh-agent)
    '' else ""}

    ### Allow user to override system-wide configuration
    if test -f ~/.xsession; then
        source ~/.xsession;
    fi
  

    ### Start a window manager.
  
    ${if windowManager == "twm" then ''
      ${xorg.twm}/bin/twm &
    ''

    else if windowManager == "metacity" then ''
      env LD_LIBRARY_PATH=${libX11}/lib:${libXext}/lib:/usr/lib/
      # !!! Hack: load the schemas for Metacity.
      GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
        --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas
      ${gnome.metacity}/bin/metacity &
    ''

    else if windowManager == "kwm" then ''
      ${kdebase}/bin/kwin &
    ''

    else if windowManager == "compiz" then ''
      # !!! Hack: load the schemas for Compiz.
      GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
        --makefile-install-rule ${compiz}/etc/gconf/schemas/*.schemas

      # !!! Hack: turn on most Compiz modules.
      ${gnome.GConf}/bin/gconftool-2 -t list --list-type=string \
        --set /apps/compiz/general/allscreens/options/active_plugins \
        [gconf,png,decoration,wobbly,fade,minimize,move,resize,cube,switcher,rotate,place,scale,water]

      # Start Compiz and the GTK-style window decorator.
      env LD_LIBRARY_PATH=${libX11}/lib:${libXext}/lib:/usr/lib/
      ${compiz}/bin/compiz gconf ${renderingFlag}&
      ${compiz}/bin/gtk-window-decorator --sync &
    ''
    
    else if windowManager == "none" then ''
      # The session starter will start the window manager.
    ''

    else abort ("unknown window manager " + windowManager)}


    ### Show a background image.
    # (but not if we're starting a full desktop environment that does it for us)
    ${if sessionType != "kde" then ''
    
      if test -e $HOME/.background-image; then
        ${feh}/bin/feh --bg-scale $HOME/.background-image
      fi
      
    '' else ""}
    

    ### Start the session.
    ${if sessionType == "kde" then ''

      # Start KDE.
      export KDEDIRS=$HOME/.nix-profile:/nix/var/nix/profiles/default:${kdebase}:${kdelibs}
      export XDG_CONFIG_DIRS=${kdebase}/etc/xdg:${kdelibs}/etc/xdg
      export XDG_DATA_DIRS=${kdebase}/share
      exec ${kdebase}/bin/startkde

    '' else ''

      # For all other session types, we currently just start a
      # terminal of the kind indicated by sessionCmd.
      # !!! yes, this means that you 'log out' by killing the X server.
      while ${sessionCmd}; do
        sleep 1  
      done

    ''}
    
  '';


  xserverArgs = [
    "-ac"
    "-logverbose"
    "-verbose"
    "-terminate"
    "-logfile" "/var/log/X.${toString display}.log"
    "-config ${configFile}"
    ":${toString display}" "vt${toString tty}"
    "-xkbdir" "${xkeyboard_config}/etc/X11/xkb"
  ] ++ optional (!config.services.xserver.tcpEnable) "-nolisten tcp";

  
  slimConfig = writeText "slim.cfg" ''
    xauth_path ${xorg.xauth}/bin/xauth
    default_xserver ${xorg.xorgserver}/bin/X
    xserver_arguments ${toString xserverArgs}
    login_cmd exec ${stdenv.bash}/bin/sh ${clientScript}
  '';


  # Unpack the SLiM theme, or use the default.
  slimThemesDir =
    let
      unpackedTheme = stdenv.mkDerivation {
        name = "slim-theme";
        buildCommand = ''
          ensureDir $out
          cd $out
          unpackFile ${cfg.slim.theme}
          ln -s * default
        '';
      };
    in if cfg.slim.theme == null then "${slim}/share/slim/themes" else unpackedTheme;       


in


rec {
  name = "xserver";

  
  extraPath = [
    xorg.xrandr
    xorg.xrdb
    xorg.setxkbmap
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
  ]
  ++ optional (sessionType == "kde") [
    kdelibs
    kdebase
    xorg.iceauth # absolutely required by dcopserver
    xorg.xset # used by startkde, non-essential
  ];


  extraEtc =
    optional (sessionType == "kde")
      { source = "${xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      }
    ++
    optional (exportConfiguration) 
      { source = "${configFile}";
        target = "X11/xorg.conf";
      };

    
  job = ''
    start on ${if autorun then "network-interfaces" else "never"}

    start script
    
      rm -f /var/run/opengl-driver
      ${if videoDriver == "nvidia"        
        then "ln -sf ${nvidiaDrivers} /var/run/opengl-driver"
	else if cfg.driSupport
        then "ln -sf ${mesa} /var/run/opengl-driver"
        else ""
       }

      rm -f /var/log/slim.log
       
    end script

    env SLIM_CFGFILE=${slimConfig}
    env SLIM_THEMESDIR=${slimThemesDir}
    env FONTCONFIG_FILE=/etc/fonts/fonts.conf  				# !!! cleanup
    env XKB_BINDIR=${xorg.xkbcomp}/bin         				# Needed for the Xkb extension.
    env LD_LIBRARY_PATH=${libX11}/lib:${libXext}/lib:/usr/lib/          # related to xorg-sys-opengl - needed to load libglx for (AI)GLX support (for compiz)

    ${if videoDriver == "nvidia"
      then "env XORG_DRI_DRIVER_PATH=${nvidiaDrivers}/X11R6/lib/modules/drivers/"
    else if cfg.driSupport
      then "env XORG_DRI_DRIVER_PATH=${mesa}/lib/modules/dri"
      else ""
    } 

    exec ${slim}/bin/slim
  '';
  
}
