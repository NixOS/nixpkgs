{ config, lib, writeScript, buildFHSUserEnv, steam, glxinfo-i686
, steam-runtime-wrapped, steam-runtime-wrapped-i686 ? null
, extraPkgs ? pkgs: [ ] # extra packages to add to targetPkgs
, extraLibraries ? pkgs: [ ] # extra packages to add to multiPkgs
, extraProfile ? "" # string to append to profile
, nativeOnly ? false
, runtimeOnly ? false
, runtimeShell

# DEPRECATED
, withJava ? config.steam.java or false
, withPrimus ? config.steam.primus or false
}:

let
  commonTargetPkgs = pkgs: with pkgs;
    [
      steamPackages.steam-fonts
      # Needed for operating system detection until
      # https://github.com/ValveSoftware/steam-for-linux/issues/5909 is resolved
      lsb-release
      # Errors in output without those
      pciutils
      python2
      # Games' dependencies
      xorg.xrandr
      which
      # Needed by gdialog, including in the steam-runtime
      perl
      # Open URLs
      xdg_utils
      iana-etc
      # Steam Play / Proton
      python3
      # Steam VR
      procps
      usbutils

      # electron based launchers need newer versions of these libraries than what runtime provides
      mesa
      sqlite
    ] ++ lib.optional withJava jdk8 # TODO: upgrade https://github.com/NixOS/nixpkgs/pull/89731
      ++ lib.optional withPrimus primus
      ++ extraPkgs pkgs;

  ldPath = map (x: "/steamrt/${steam-runtime-wrapped.arch}/" + x) steam-runtime-wrapped.libs
           ++ lib.optionals (steam-runtime-wrapped-i686 != null) (map (x: "/steamrt/${steam-runtime-wrapped-i686.arch}/" + x) steam-runtime-wrapped-i686.libs);

  # Zachtronics and a few other studios expect STEAM_LD_LIBRARY_PATH to be present
  exportLDPath = ''
    export LD_LIBRARY_PATH=/lib32:/lib64:${lib.concatStringsSep ":" ldPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
    export STEAM_LD_LIBRARY_PATH="$STEAM_LD_LIBRARY_PATH''${STEAM_LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  setupSh = writeScript "setup.sh" ''
    #!${runtimeShell}
  '';

  runSh = writeScript "run.sh" ''
    #!${runtimeShell}
    runtime_paths="/lib32:/lib64:${lib.concatStringsSep ":" ldPath}"
    if [ "$1" == "--print-steam-runtime-library-paths" ]; then
      echo "$runtime_paths''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
      exit 0
    fi
    export LD_LIBRARY_PATH="$runtime_paths''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export STEAM_LD_LIBRARY_PATH="$STEAM_LD_LIBRARY_PATH''${STEAM_LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    exec "$@"
  '';

in buildFHSUserEnv rec {
  name = "steam";

  targetPkgs = pkgs: with pkgs; [
    steamPackages.steam
    # License agreement
    gnome3.zenity
  ] ++ commonTargetPkgs pkgs;

  multiPkgs = pkgs: with pkgs; [
    # These are required by steam with proper errors
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva

    # Not formally in runtime but needed by some games
    at-spi2-atk
    at-spi2-core   # CrossCode
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-base
    libdrm
    mono
    xorg.xkeyboardconfig
    xorg.libpciaccess
    udev # shadow of the tomb raider

    ## screeps dependencies
    gtk3
    dbus
    zlib
    glib
    atk
    cairo
    freetype
    gdk-pixbuf
    pango
    fontconfig

    # friends options won't display "Launch Game" without it
    lsof

    # called by steam's setup.sh
    file

    # Prison Architect
    libGLU
    libuuid
    libbsd
    alsaLib
  ] ++ (if (!nativeOnly) then [
    (steamPackages.steam-runtime-wrapped.override {
      inherit runtimeOnly;
    })
  ] else [
    # Required
    glib
    gtk2
    bzip2
    zlib
    gdk-pixbuf

    # Without these it silently fails
    xorg.libXinerama
    xorg.libXdamage
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXxf86vm
    xorg.libXi
    xorg.libSM
    xorg.libICE
    gnome2.GConf
    freetype
    (curl.override { gnutlsSupport = true; sslSupport = false; })
    nspr
    nss
    fontconfig
    cairo
    pango
    expat
    dbus
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    libav
    atk
    # Only libraries are needed from those two
    libudev0-shim
    networkmanager098

    # Verified games requirements
    xorg.libXt
    xorg.libXmu
    xorg.libxcb
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    openssl
    libidn
    tbb
    wayland
    libxkbcommon

    # Other things from runtime
    flac
    freeglut
    libjpeg
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    xorg.libXft
    libvdpau
  ] ++ steamPackages.steam-runtime-wrapped.overridePkgs) ++ extraLibraries pkgs;

  extraBuildCommands = if (!nativeOnly) then ''
    mkdir -p steamrt
    ln -s ../lib/steam-runtime steamrt/${steam-runtime-wrapped.arch}
    ${lib.optionalString (steam-runtime-wrapped-i686 != null) ''
      ln -s ../lib32/steam-runtime steamrt/${steam-runtime-wrapped-i686.arch}
    ''}
    ln -s ${runSh} steamrt/run.sh
    ln -s ${setupSh} steamrt/setup.sh
  '' else ''
    ln -s /usr/lib/libbz2.so usr/lib/libbz2.so.1.0
    ${lib.optionalString (steam-runtime-wrapped-i686 != null) ''
      ln -s /usr/lib32/libbz2.so usr/lib32/libbz2.so.1.0
    ''}
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -s ${steam}/share/icons $out/share
    ln -s ${steam}/share/pixmaps $out/share
    sed "s,/usr/bin/steam,steam,g" ${steam}/share/applications/steam.desktop > $out/share/applications/steam.desktop
  '';

  profile = ''
    # Workaround for issue #44254 (Steam cannot connect to friends network)
    # https://github.com/NixOS/nixpkgs/issues/44254
    if [ -z ''${TZ+x} ]; then
      new_TZ="$(readlink -f /etc/localtime | grep -P -o '(?<=/zoneinfo/).*$')"
      if [ $? -eq 0 ]; then
        export TZ="$new_TZ"
      fi
    fi

    export STEAM_RUNTIME=${if nativeOnly then "0" else "/steamrt"}
  '' + extraProfile;

  runScript = writeScript "steam-wrapper.sh" ''
    #!${runtimeShell}
    if [ -f /host/etc/NIXOS ]; then   # Check only useful on NixOS
      ${glxinfo-i686}/bin/glxinfo >/dev/null 2>&1
      # If there was an error running glxinfo, we know something is wrong with the configuration
      if [ $? -ne 0 ]; then
        cat <<EOF > /dev/stderr
    **
    WARNING: Steam is not set up. Add the following options to /etc/nixos/configuration.nix
    and then run \`sudo nixos-rebuild switch\`:
    {
      hardware.opengl.driSupport32Bit = true;
      hardware.pulseaudio.support32Bit = true;
    }
    **
    EOF
      fi
    fi
    ${lib.optionalString (!nativeOnly) exportLDPath}
    exec steam "$@"
  '';

  meta = steam.meta // {
    broken = nativeOnly;
  };

  # allows for some gui applications to share IPC
  # this fixes certain issues where they don't render correctly
  unshareIpc = false;

  passthru.run = buildFHSUserEnv {
    name = "steam-run";

    targetPkgs = commonTargetPkgs;
    inherit multiPkgs extraBuildCommands;

    runScript = writeScript "steam-run" ''
      #!${runtimeShell}
      run="$1"
      if [ "$run" = "" ]; then
        echo "Usage: steam-run command-to-run args..." >&2
        exit 1
      fi
      shift
      ${lib.optionalString (!nativeOnly) exportLDPath}
      exec -- "$run" "$@"
    '';
  };
}
