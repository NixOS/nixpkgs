{config, pkgs, kernelPackages, fontDirectories}:

let
  # Abbreviations.
  cfg = config.services.xserver;
  xorg = cfg.package;
  
  inherit (pkgs.lib) optional isInList attrByPath;
  stdenv = pkgs.stdenv;
  
  knownVideoDrivers = {
    nvidia = { modulesFirst = [ kernelPackages.nvidia_x11 ]; };  #make sure it first loads the nvidia libs
    vesa =   { modules = [xorg.xf86videovesa]; };
    vga =    { modules = [xorg.xf86videovga]; };
    sis =    { modules = [xorg.xf86videosis]; };
    i810 =   { modules = [xorg.xf86videoi810]; };
    intel =  { modules = [xorg.xf86videointel]; };
    nv =     { modules = [xorg.xf86videonv]; };
    ati =    { modules = [xorg.xf86videoati]; };
    via =    { modules = [xorg.xf86videovia]; };
    cirrus = { modules = [xorg.xf86videocirrus]; };
  };

  # Get a bunch of user settings.
  videoDriver = cfg.videoDriver;
  resolutions = map (res: ''"${toString res.x}x${toString res.y}"'') (cfg.resolutions);
  sessionType = cfg.sessionType;

  videoDriverModules = attrByPath [ videoDriver ] (throw "unknown video driver: `${videoDriver}'") knownVideoDrivers;

  modules = 

    attrByPath ["modulesFirst"] [] videoDriverModules
    ++ [
      xorg.xorgserver
      xorg.xf86inputkeyboard
      xorg.xf86inputmouse
    ] 
    ++ attrByPath ["modules"] [] videoDriverModules
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

    setCorePointer = 
      if cfg.synaptics.enable then ''
        InputDevice "Touchpad[0]" "CorePointer"
      '' else "";

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


  xsession = pkgs.writeText "Xsession" ''
    source /etc/profile
    
    session=$1
    
    export PATH=$PATH:${pkgs.xterm}/bin:${pkgs.qt4}/bin:${pkgs.dbus.libs}/bin:${pkgs.kde42.kdelibs}/bin:${pkgs.kde42.kdebase_workspace}/bin:${pkgs.xlibs.xset}/bin:${pkgs.xlibs.xsetroot}/bin:${pkgs.xlibs.xmessage}/bin:${pkgs.xlibs.xprop}/bin
    export XDG_CONFIG_DIRS=
    export XDG_DATA_DIRS=${pkgs.shared_mime_info}/share
    export KDEDIRS=${pkgs.kde42.kdelibs}:${pkgs.kde42.kdebase_workspace}
    
    case $session in
      "")
        xmessage -center -buttons OK:0 -default OK "Sorry, $DESKTOP_SESSION is no valid session."
        ;;
      failsafe)
        xterm -geometry 80x24-0-0
        ;;
      custom)
        $HOME/.xsession
      ;;
      default)
        startkde
        ;;
      *)
      eval "$session"
      ;;
    esac

    exec xmessage -center -buttons OK:0 -default OK "Sorry, cannot execute $session. Check $DESKTOP_SESSION.desktop."
  '';
 
  kdmrc = stdenv.mkDerivation {
    name = "kdmrc";
    buildCommand = ''
      cp ${pkgs.kde42.kdebase_workspace}/share/config/kdm/kdmrc .
      sed -i -e "s|#HaltCmd=|HaltCmd=${pkgs.upstart}/sbin/halt|" \
             -e "s|#RebootCmd=|RebootCmd=${pkgs.upstart}/sbin/reboot|" \
	     -e "s|#Xrdb=|Xrdb=${pkgs.xlibs.xrdb}/bin/xrdb|" \
	     -e "s|#HiddenUsers=root|HiddenUsers=root,nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10|" \
	     -e "s|ServerCmd=/FOO/bin/X|ServerCmd=${pkgs.xlibs.xorgserver}/bin/X -config ${configFile} -xkbdir ${pkgs.xkeyboard_config}/etc/X11/xkb|" \
	     -e "s|Session=${pkgs.kde42.kdebase_workspace}/share/config/kdm/Xsession|Session=${xsession}|" \
	     -e "s|#FailsafeClient=|FailsafeClient=${pkgs.xterm}/bin/xterm|" \
	     -e "s|#PluginsLogin=sign|PluginsLogin=${pkgs.kde42.kdebase_workspace}/lib/kde4/kgreet_classic.so|" \
      kdmrc
      ensureDir $out
      cp kdmrc $out
    '';
  };
in
{
  name = "kdm";
      
  job = ''
    description "KDE Display Manager"

    start script
    
      rm -f /var/run/opengl-driver
      ${if videoDriver == "nvidia"        
        then ''
          ln -sf ${kernelPackages.nvidia_x11} /var/run/opengl-driver
        ''
        else if cfg.driSupport
        then "ln -sf ${pkgs.mesa} /var/run/opengl-driver"
        else ""
       }

      rm -f /tmp/.X0-lock
       
    end script

    ${if videoDriver == "nvidia" 
      then "env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11}/lib" 
      else ""
    }

    ${if videoDriver != "nvidia"
      then "env XORG_DRI_DRIVER_PATH=${pkgs.mesa}/lib/modules/dri"
      else ""
    }
    
    env FONTCONFIG_FILE=/etc/fonts/fonts.conf # !!! cleanup
    env XKB_BINDIR=${xorg.xkbcomp}/bin # Needed for the Xkb extension.
    
    respawn ${pkgs.kde42.kdebase_workspace}/bin/kdm -config ${kdmrc}/kdmrc
  '';
}
