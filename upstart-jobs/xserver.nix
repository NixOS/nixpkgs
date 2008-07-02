{ config, pkgs, kernelPackages

, # List of font directories.
  fontDirectories
}:

let

  optional = condition: x: if condition then [x] else [];

  # Abbreviations.
  cfg = config.services.xserver;
  xorg = cfg.packageFun pkgs;
  gnome = pkgs.gnome;
  stdenv = pkgs.stdenv;

  # Get a bunch of user settings.
  videoDriver = cfg.videoDriver;
  resolutions = map (res: ''"${toString res.x}x${toString res.y}"'') (cfg.resolutions);
  sessionType = cfg.sessionType;


  sessionCmd =
    if sessionType == "" then cfg.sessionStarter else
    if sessionType == "xterm" then "${pkgs.xterm}/bin/xterm -ls" else
    if sessionType == "gnome" then "${gnome.gnometerminal}/bin/gnome-terminal -ls" else
    abort ("unknown session type ${sessionType}");


  windowManager =
    let wm = cfg.windowManager; in
    if wm != "" then wm else
    if sessionType == "gnome" then "metacity" else
    if sessionType == "kde" then "none" /* started by startkde */ else
    "twm";

    
  modules = 
    optional (videoDriver == "nvidia") kernelPackages.nvidiaDrivers #make sure it first loads the nvidia libs
    ++ [
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
    ++ optional (videoDriver == "radeonhd") xorg.xf86videoradeonhd
    ++ (optional cfg.synaptics.enable ["${pkgs.synaptics}/${xorg.xorgserver}" /*xorg.xf86inputevdev*/]);


  configFile = stdenv.mkDerivation {
    name = "xserver.conf";
    src = ./xserver.conf;
    inherit fontDirectories videoDriver resolutions;
    isClone = if cfg.isClone then "on" else "off";

    synapticsInputDevice = if cfg.synaptics.enable then ''
      Section "InputDevice"
        Identifier "Touchpad[0]"
        Driver "synaptics"
        Option "Device" "${cfg.synaptics.dev}"
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
        Option "MinSpeed" "${cfg.synaptics.minSpeed}"
        Option "MaxSpeed" "${cfg.synaptics.maxSpeed}"
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

    xkbModel = cfg.xkbModel;
    layout = cfg.layout;

    corePointer = if cfg.synaptics.enable then "Touchpad[0]" else "Mouse[0]";

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
        if ls $i/*.so* > /dev/null 2>&1; then
          modulePaths="''${modulePaths}ModulePath \"$i\"''\n"
        fi
      done

      export moduleSection=""
      export screen=""
      export device=""
      export extensions=""


      #if only my gf were this dirty
      if test "${toString videoDriver}" == "nvidia"; then
        export screen='
          Option "AddARGBGLXVisuals" "true"
          Option "DisableGLXRootClipping" "true"
	  Option "RandRRotation" "on"
        '
        
        export device='
          Option "RenderAccel" "true"
          Option "AllowGLXWithComposite" "true"
          Option "AddARGBGLXVisuals" "true"
        '
        
        export extensions='
          Option "Composite" "Enable"
        '
      fi
	
      if [ "${toString videoDriver}" = i810 ]; then
        export extensions='
          Option "Composite" "Enable"
        ';
      fi;

      if [ "${toString videoDriver}" = ati ]; then
        export extensions='
          Option "Composite" "Enable"
        ';
      fi;

      if [ "${toString videoDriver}" = radeonhd ]; then
        export extensions='
          Option "Composite" "Enable"
        ';
      fi;

      substituteAll $src $out
    ''; # */
  };


  clientScript = pkgs.writeText "xclient" ''

    source /etc/profile

    exec > $HOME/.Xerrors 2>&1


    ### Load X defaults.
    if test -e ~/.Xdefaults; then
      ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
    fi


    ${if cfg.startSSHAgent then ''
      ### Start the SSH agent.
      export SSH_ASKPASS=${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass
      eval $(${pkgs.openssh}/bin/ssh-agent)
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
      env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:/usr/lib/
      # !!! Hack: load the schemas for Metacity.
      GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
        --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas
      ${gnome.metacity}/bin/metacity &
    ''

    else if windowManager == "kwm" then ''
      ${pkgs.kdebase}/bin/kwin &
    ''

    else if windowManager == "compiz" then ''
      # !!! Hack: load the schemas for Compiz.
      GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
        --makefile-install-rule ${pkgs.compiz}/etc/gconf/schemas/*.schemas

      # !!! Hack: turn on most Compiz modules.
      ${gnome.GConf}/bin/gconftool-2 -t list --list-type=string \
        --set /apps/compiz/general/allscreens/options/active_plugins \
        [gconf,png,decoration,wobbly,fade,minimize,move,resize,cube,switcher,rotate,place,scale,water]

      # Start Compiz and the GTK-style window decorator.
      env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:/usr/lib/
      ${pkgs.compiz}/bin/compiz gconf ${cfg.renderingFlag} &
      ${pkgs.compiz}/bin/gtk-window-decorator --sync &
    ''

    else if windowManager == "xmonad" then ''
      ${pkgs.xmonad}/bin/xmonad &
    ''
    
    else if windowManager == "none" then ''
      # The session starter will start the window manager.
    ''

    else abort ("unknown window manager " + windowManager)}


    ### Show a background image.
    # (but not if we're starting a full desktop environment that does it for us)
    ${if sessionType != "kde" then ''
    
      if test -e $HOME/.background-image; then
        ${pkgs.feh}/bin/feh --bg-scale $HOME/.background-image
      fi
      
    '' else ""}
    

    ### Start the session.
    ${if sessionType == "kde" then ''

      # Start KDE.
      export KDEDIRS=$HOME/.nix-profile:/nix/var/nix/profiles/default:${pkgs.kdebase}:${pkgs.kdelibs}
      export XDG_CONFIG_DIRS=${pkgs.kdebase}/etc/xdg:${pkgs.kdelibs}/etc/xdg
      export XDG_DATA_DIRS=${pkgs.kdebase}/share
      exec ${pkgs.kdebase}/bin/startkde

    '' else ''

      # For all other session types, we currently just start a
      # terminal of the kind indicated by sessionCmd.
      # !!! yes, this means that you 'log out' by killing the X server.
      while ${sessionCmd}; do
        sleep 1  
      done

    ''}
    
  ''; # */


  xserverArgs = [
    "-ac"
    "-logverbose"
    "-verbose"
    "-terminate"
    "-logfile" "/var/log/X.${toString cfg.display}.log"
    "-config ${configFile}"
    ":${toString cfg.display}" "vt${toString cfg.tty}"
    "-xkbdir" "${pkgs.xkeyboard_config}/etc/X11/xkb"
  ] ++ optional (!config.services.xserver.tcpEnable) "-nolisten tcp";

  
  slimConfig = pkgs.writeText "slim.cfg" ''
    xauth_path ${xorg.xauth}/bin/xauth
    default_xserver ${xorg.xorgserver}/bin/X
    xserver_arguments ${toString xserverArgs}
    login_cmd exec ${stdenv.bash}/bin/sh ${clientScript}
    halt_cmd ${pkgs.upstart}/sbin/shutdown -h now
    reboot_cmd ${pkgs.upstart}/sbin/shutdown -r now
    ${if cfg.slim.defaultUser != "" then "default_user " + cfg.slim.defaultUser else ""}
    ${if cfg.slim.hideCursor then "hidecursor true" else ""}
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
    in if cfg.slim.theme == null then "${pkgs.slim}/share/slim/themes" else unpackedTheme;       

    nvidiaDrivers = (config.boot.kernelPackages pkgs).nvidiaDrivers;

in


rec {
  name = "xserver";

  
  extraPath = [
    xorg.xrandr
    xorg.xrdb
    xorg.setxkbmap
    pkgs.feh
  ]
  ++ optional (windowManager == "twm") [
    xorg.twm
  ]
  ++ optional (windowManager == "metacity") [
    gnome.metacity
  ]
  ++ optional (windowManager == "compiz") [
    pkgs.compiz
  ]
  ++ optional (sessionType == "xterm") [
    pkgs.xterm
  ]
  ++ optional (sessionType == "gnome") [
    gnome.gnometerminal
    gnome.GConf
    gnome.gconfeditor
  ]
  ++ optional (sessionType == "kde") [
    pkgs.kdelibs
    pkgs.kdebase
    xorg.iceauth # absolutely required by dcopserver
    xorg.xset # used by startkde, non-essential
  ]
  ++ optional (videoDriver == "nvidia") [
    kernelPackages.nvidiaDrivers
  ];


  extraEtc =
    optional (sessionType == "kde")
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      }
    ++
    optional cfg.exportConfiguration
      { source = "${configFile}";
        target = "X11/xorg.conf";
      };

    
  job = ''
    start on ${if cfg.autorun then "network-interfaces" else "never"}

    start script
    
      rm -f /var/run/opengl-driver
      ${if videoDriver == "nvidia"        
        then ''
          ln -sf ${kernelPackages.nvidiaDrivers} /var/run/opengl-driver
        ''
	else if cfg.driSupport
        then "ln -sf ${pkgs.mesa} /var/run/opengl-driver"
        else ""
       }

      rm -f /var/log/slim.log
       
    end script

    env SLIM_CFGFILE=${slimConfig}
    env SLIM_THEMESDIR=${slimThemesDir}
    env FONTCONFIG_FILE=/etc/fonts/fonts.conf # !!! cleanup
    env XKB_BINDIR=${xorg.xkbcomp}/bin # Needed for the Xkb extension.

    ${if videoDriver == "nvidia" 
      then "env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidiaDrivers}/lib" 
      else ""
    }

    ${if videoDriver != "nvidia"
      then "env XORG_DRI_DRIVER_PATH=${pkgs.mesa}/lib/modules/dri"
      else ""
    }

    exec ${pkgs.slim}/bin/slim
  '';
  
}
