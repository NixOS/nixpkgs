{config, pkgs, ...}:
# TODO: this file need some make-up (Nicolas Pierron)

let
  kernelPackages = config.boot.kernelPackages;
  # List of font directories.
  fontDirectories = config.fonts.fonts;

  inherit (pkgs.lib) mkOption;

  options = {
    services = {

      xserver = {

        enable = mkOption {
          default = false;
          description = "
            Whether to enable the X server.
          ";
        };

        autorun = mkOption {
          default = true;
          description = "
            Switch to false to create upstart-job and configuration, 
            but not run it automatically
          ";
        };

        exportConfiguration = mkOption {
          default = false;
          description = "
            Create /etc/X11/xorg.conf and a file with environment
            variables
          ";
        };

        tcpEnable = mkOption {
          default = false;
          description = "
            Whether to enable TCP socket for the X server.
          ";
        };

        resolutions = mkOption {
          default = [{x = 1024; y = 768;} {x = 800; y = 600;} {x = 640; y = 480;}];
          description = "
            The screen resolutions for the X server.  The first element is the default resolution.
          ";
        };

        videoDriver = mkOption {
          default = "vesa";
          example = "i810";
          description = "
            The name of the video driver for your graphics card.
          ";
        };

        driSupport = mkOption {
          default = false;
          description = "
            Whether to enable accelerated OpenGL rendering through the
            Direct Rendering Interface (DRI).
          ";
        };

        sessionType = mkOption {
          default = "gnome";
          example = "xterm";
          description = "
            The kind of session to start after login.  Current possibilies
            are <literal>kde</literal> (which starts KDE),
            <literal>gnome</literal> (which starts
            <command>gnome-terminal</command>) and <literal>xterm</literal>
            (which starts <command>xterm</command>).
          ";
        };

        windowManager = mkOption {
          default = "";
          description = "
            This option selects the window manager.  Available values are
            <literal>twm</literal> (extremely primitive),
            <literal>metacity</literal>, <literal>xmonad</literal>
            and <literal>compiz</literal>.  If
            left empty, the <option>sessionType</option> determines the
            window manager, e.g., Metacity for Gnome, and
            <command>kwm</command> for KDE.
          ";
        };

        renderingFlag = mkOption {
          default = "";
          example = "--indirect-rendering";
          description = "
            Possibly pass --indierct-rendering to Compiz.
          ";
        };

        sessionStarter = mkOption {
          example = "${pkgs.xterm}/bin/xterm -ls";
          description = "
            The command executed after login and after the window manager
            has been started.  Used if
            <option>services.xserver.sessionType</option> is empty.
          ";
        };

        startSSHAgent = mkOption {
          default = true;
          description = "
            Whether to start the SSH agent when you log in.  The SSH agent
            remembers private keys for you so that you don't have to type in
            passphrases every time you make an SSH connection.  Use
            <command>ssh-add</command> to add a key to the agent.
          ";
        };

        slim = {

          theme = mkOption {
            default = null;
            example = pkgs.fetchurl {
              url = http://download.berlios.de/slim/slim-wave.tar.gz;
              sha256 = "0ndr419i5myzcylvxb89m9grl2xyq6fbnyc3lkd711mzlmnnfxdy";
            };
            description = "
              The theme for the SLiM login manager.  If not specified, SLiM's
              default theme is used.  See <link
              xlink:href='http://slim.berlios.de/themes01.php'/> for a
              collection of themes.
            ";
          };

          defaultUser = mkOption {
            default = "";
            example = "login";
            description = "
              The default user to load. If you put a username here you
              get it automatically loaded into the username field, and
              the focus is placed on the password.
            ";
          };

          hideCursor = mkOption {
            default = false;
            example = true;
            description = "
              Hide the mouse cursor on the login screen.
            ";
          };
        };

        isClone = mkOption {
          default = true;
          example = false;
          description = "
            Whether to enable the X server clone mode for dual-head.
          ";
        };

        synaptics = {
          enable = mkOption {
            default = false;
            example = true;
            description = "
              Whether to replace mouse with touchpad.
            ";
          };
          dev = mkOption {
            default = "/dev/input/event0";
            description = "
              Event device for Synaptics touchpad.
            ";
          };
          minSpeed = mkOption {
            default = "0.06";
            description = "Cursor speed factor for precision finger motion";
          };
          maxSpeed = mkOption {
            default = "0.12";
            description = "Cursor speed factor for highest-speed finger motion";
          };
          twoFingerScroll = mkOption {
            default = false;
            description = "Whether to enable two-finger drag-scrolling";
          };
        };

        layout = mkOption {
          default = "us";
          description = "
            Keyboard layout.
          ";
        };

        xkbModel = mkOption {
          default = "pc104";
          example = "presario";
          description = "
            Keyboard model.
          ";
        };

        xkbOptions = mkOption {
          default = "";
          example = "grp:caps_toggle, grp_led:scroll";
          description = "
            X keyboard options; layout switching goes here.
          ";
        };

        useInternalAGPGART = mkOption {
          default = "";
          example = "no";
          description = "
            Just the wrapper for an xorg.conf option.
          ";
        };

        extraDeviceConfig = mkOption {
          default = "";
          example = "VideoRAM 131072";
          description = "
            Just anything to add into Device section.
          ";
        };

        extraMonitorSettings = mkOption {
          default = "";
          example = "HorizSync 28-49";
          description = "
            Just anything to add into Monitor section.
          ";
        };

        extraDisplaySettings = mkOption {
          default = "";
          example = "Virtual 2048 2048";
          description = "
            Just anything to add into Display subsection (located in Screen section).
          ";
        };
   
        extraModules = mkOption {
          default = "";
          example = "
            SubSection \"extmod\"
            EndSubsection
          ";
          description = "
            Just anything to add into Modules section.
          ";
        };

        serverLayoutOptions = mkOption {
          default = "";
          example = "
            Option \"AIGLX\" \"true\"
          ";
          description = "
            Just anything to add into Monitor section.
          ";
        };

        defaultDepth = mkOption {
          default = 24;
          example = 8;
          description = "
            Default colour depth.
          ";
        };
        
        useXFS = mkOption {
          default = false;
          example = "unix/:7100";
          description = "
            Way to access the X Font Server to use.
          ";
        };

        tty = mkOption {
          default = 7;
          example = 9;
          description = "
            Virtual console for the X server.
          ";
        };

        display = mkOption {
          default = 0;
          example = 1;
          description = "
            Display number for the X server.
          ";
        };

        package = mkOption {
          default = pkgs.xorg;
          description = "
            Alternative X.org package to use. For 
            example, you can replace individual drivers.
          ";
        };

        virtualScreen = mkOption {
          default = null;
          example = {
            x=2048;
            y=2048;
          };
          description = "
            Virtual screen size for Xrandr
          ";
        };
      };

    };
  };
in

let

  inherit (pkgs.lib) optional isInList getAttr mkIf;
  # Abbreviations.
  cfg = config.services.xserver;
  xorg = cfg.package;
  gnome = pkgs.gnome;
  stdenv = pkgs.stdenv;

  knownVideoDrivers = {
    nvidia = { modulesFirst = [ kernelPackages.nvidiaDrivers ]; };  #make sure it first loads the nvidia libs
    vesa =  { modules = [xorg.xf86videovesa]; };
    vga =   { modules = [xorg.xf86videovga]; };
    sis =   { modules = [xorg.xf86videosis]; };
    i810 =  { modules = [xorg.xf86videoi810]; };
    intel = { modules = [xorg.xf86videointel]; };
    nv =    { modules = [xorg.xf86videonv]; };
    ati =   { modules = [xorg.xf86videoati]; };
  };

  # Get a bunch of user settings.
  videoDriver = cfg.videoDriver;
  resolutions = map (res: ''"${toString res.x}x${toString res.y}"'') (cfg.resolutions);
  sessionType = cfg.sessionType;

  videoDriverModules = getAttr [ videoDriver ] (throw "unkown video driver : \"${videoDriver}\"") knownVideoDrivers;

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

    getAttr ["modulesFirst"] [] videoDriverModules
    ++ [
      xorg.xorgserver
      xorg.xf86inputkeyboard
      xorg.xf86inputmouse
    ] 
    ++ getAttr ["modules"] [] videoDriverModules
    ++ (optional cfg.synaptics.enable ["${pkgs.synaptics}/${xorg.xorgserver}" /*xorg.xf86inputevdev*/]);


  fontsForXServer =
    fontDirectories ++
    # We don't want these fonts in fonts.conf, because then modern,
    # fontconfig-based applications will get horrible bitmapped
    # Helvetica fonts.  It's better to get a substitution (like Nimbus
    # Sans) than that horror.  But we do need the Adobe fonts for some
    # old non-fontconfig applications.  (Possibly this could be done
    # better using a fontconfig rule.)
    [ pkgs.xorg.fontadobe100dpi
      pkgs.xorg.fontadobe75dpi
    ];
    

  configFile = stdenv.mkDerivation {
    name = "xserver.conf";
    src = ./xserver.conf;
    inherit fontsForXServer videoDriver resolutions;
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
        Option "VertTwoFingerScroll" "${if cfg.synaptics.twoFingerScroll then "1" else "0"}"
        Option "HorizTwoFingerScroll" "${if cfg.synaptics.twoFingerScroll then "1" else "0"}"
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
    virtualScreen = if cfg.virtualScreen != null then 
        "Virtual ${toString cfg.virtualScreen.x} ${toString cfg.virtualScreen.y}" 
      else "";

    xfs = if cfg.useXFS == false then "" else 
      ''FontPath "${toString cfg.useXFS}"'';

    buildCommand = ''
      buildCommand= # urgh, don't substitute this

      export fontPaths=
      for i in $fontsForXServer; do
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
        --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas # */
      ${gnome.metacity}/bin/metacity &
    ''

    else if windowManager == "kwm" then ''
      ${pkgs.kdebase}/bin/kwin &
    ''

    else if windowManager == "compiz" then ''
      # !!! Hack: load the schemas for Compiz.
      GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
        --makefile-install-rule ${pkgs.compiz}/etc/gconf/schemas/*.schemas # */

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
    WMpid=$!

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
    
  '';


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

  oldJob = rec {
  # Warning the indentation is wrong since here in order to don't produce noise in diffs.

  name = "xserver";

  
  extraPath = [
    xorg.xrandr
    xorg.xrdb
    xorg.setxkbmap
    xorg.iceauth # required for KDE applications (it's called by dcopserver)
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
  
};

in

mkIf cfg.enable {
  require = [
    options

    # services.extraJobs
    (import ../upstart-jobs/default.nix)

    # environment.etc
    (import ../etc/default.nix)

    # fonts.fonts
    (import ../system/fonts.nix)

    # boot.extraModulePackages
    # security.extraSetuidPrograms
    # environment.extraPackages
  ];

  boot = {
    extraModulePackages = mkIf (cfg.videoDriver == "nvidia") [
      kernelPackages.nvidiaDrivers
    ];
  };

  security = {
    extraSetuidPrograms = mkIf (cfg.sessionType == "kde") [
      "kcheckpass"
    ];
  };

  environment = {
    etc = [
      { source = ../etc/pam.d/kde;
        target = "pam.d/kde";
      }
      { source = ../etc/pam.d/slim;
        target = "pam.d/slim";
      }
    ] ++ oldJob.extraEtc;

    extraPackages =
      oldJob.extraPath;
  };

  services = {
    extraJobs = [{
      inherit (oldJob) name job;
    }];
  };
}
