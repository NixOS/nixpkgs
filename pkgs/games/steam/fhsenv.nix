{ lib, stdenv, writeShellScript, buildFHSEnv, steam, glxinfo-i686
, steam-runtime-wrapped, steam-runtime-wrapped-i686 ? null
, extraPkgs ? pkgs: [ ] # extra packages to add to targetPkgs
, extraLibraries ? pkgs: [ ] # extra packages to add to multiPkgs
, extraProfile ? "" # string to append to profile
, extraPreBwrapCmds ? "" # extra commands to run before calling bubblewrap (real default is at usage site)
, extraBwrapArgs ? [ ] # extra arguments to pass to bubblewrap (real default is at usage site)
, extraArgs ? "" # arguments to always pass to steam
, extraEnv ? { } # Environment variables to pass to Steam

# steamwebhelper deletes unrelated electron programs' singleton cookies from /tmp on startup:
# https://github.com/ValveSoftware/steam-for-linux/issues/9121
, privateTmp ? true # Whether to separate steam's /tmp from the host system

, withGameSpecificLibraries ? true # include game specific libraries
}@args:

let
  commonTargetPkgs = pkgs: with pkgs; [
    # Needed for operating system detection until
    # https://github.com/ValveSoftware/steam-for-linux/issues/5909 is resolved
    lsb-release
    # Errors in output without those
    pciutils
    # run.sh wants ldconfig
    glibc.bin
    # Games' dependencies
    xorg.xrandr
    which
    # Needed by gdialog, including in the steam-runtime
    perl
    # Open URLs
    xdg-utils
    iana-etc
    # Steam Play / Proton
    python3
    # Steam VR
    procps
    usbutils

    # It tries to execute xdg-user-dir and spams the log with command not founds
    xdg-user-dirs

    # electron based launchers need newer versions of these libraries than what runtime provides
    mesa
    sqlite
  ] ++ extraPkgs pkgs;

  ldPath = lib.optionals stdenv.is64bit [ "/lib64" ]
  ++ [ "/lib32" ]
  ++ map (x: "/steamrt/${steam-runtime-wrapped.arch}/" + x) steam-runtime-wrapped.libs
  ++ lib.optionals (steam-runtime-wrapped-i686 != null) (map (x: "/steamrt/${steam-runtime-wrapped-i686.arch}/" + x) steam-runtime-wrapped-i686.libs);

  # Zachtronics and a few other studios expect STEAM_LD_LIBRARY_PATH to be present
  exportLDPath = ''
    export LD_LIBRARY_PATH=${lib.concatStringsSep ":" ldPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
    export STEAM_LD_LIBRARY_PATH="$STEAM_LD_LIBRARY_PATH''${STEAM_LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  # bootstrap.tar.xz has 444 permissions, which means that simple deletes fail
  # and steam will not be able to start
  fixBootstrap = ''
    if [ -r $HOME/.local/share/Steam/bootstrap.tar.xz ]; then
      chmod +w $HOME/.local/share/Steam/bootstrap.tar.xz
    fi
  '';

  envScript = ''
    # prevents various error messages
    unset GIO_EXTRA_MODULES

    # This is needed for IME (e.g. iBus, fcitx5) to function correctly on non-CJK locales
    # https://github.com/ValveSoftware/steam-for-linux/issues/781#issuecomment-2004757379
    GTK_IM_MODULE='xim'
  '' + lib.toShellVars extraEnv;

in buildFHSEnv rec {
  name = "steam";

  # Steam still needs 32bit and various native games do too
  multiArch = true;

  targetPkgs = pkgs: with pkgs; [
    steam
    # License agreement
    gnome.zenity
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
    pipewire

    # steamwebhelper
    harfbuzz
    libthai
    pango

    lsof # friends options won't display "Launch Game" without it
    file # called by steam's setup.sh

    # dependencies for mesa drivers, needed inside pressure-vessel
    mesa.llvmPackages.llvm.lib
    vulkan-loader
    expat
    wayland
    xorg.libxcb
    xorg.libXdamage
    xorg.libxshmfence
    xorg.libXxf86vm
    elfutils

    # Without these it silently fails
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXi
    xorg.libSM
    xorg.libICE
    gnome2.GConf
    curlWithGnuTls
    nspr
    nss
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    gsettings-desktop-schemas
    ffmpeg
    libudev0-shim

    # Verified games requirements
    fontconfig
    freetype
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libdrm
    libidn
    tbb
    zlib

    # SteamVR
    udev
    dbus

    # Other things from runtime
    glib
    gtk2
    bzip2
    flac
    freeglut
    libjpeg
    libpng
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
    libdbusmenu-gtk2
    libindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libunwind
    libvpx
    librsvg
    xorg.libXft
    libvdpau

    # required by coreutils stuff to run correctly
    # Steam ends up with LD_LIBRARY_PATH=/usr/lib:<bunch of runtime stuff>:<etc>
    # which overrides DT_RUNPATH in our binaries, so it tries to dynload the
    # very old versions of stuff from the runtime.
    # FIXME: how do we even fix this correctly
    attr
    # same thing, but for Xwayland (usually via gamescope), already in the closure
    libkrb5
    keyutils
  ] ++ lib.optionals withGameSpecificLibraries [
    # Not formally in runtime but needed by some games
    at-spi2-atk
    at-spi2-core   # CrossCode
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-base
    json-glib # paradox launcher (Stellaris)
    libdrm
    libxkbcommon # paradox launcher
    libvorbis # Dead Cells
    libxcrypt # Alien Isolation, XCOM 2, Company of Heroes 2
    mono
    ncurses # Crusader Kings III
    openssl
    xorg.xkeyboardconfig
    xorg.libpciaccess
    xorg.libXScrnSaver # Dead Cells
    icu # dotnet runtime, e.g. Stardew Valley

    # screeps dependencies
    gtk3
    zlib
    atk
    cairo
    freetype
    gdk-pixbuf
    fontconfig

    # Prison Architect
    libGLU
    libuuid
    libbsd
    alsa-lib

    # Loop Hero
    # FIXME: Also requires openssl_1_1, which is EOL. Either find an alternative solution, or remove these dependencies (if not needed by other games)
    libidn2
    libpsl
    nghttp2.lib
    rtmpdump
  ]
  # This needs to come from pkgs as the passed-in steam-runtime-wrapped may not be the same architecture
  ++ pkgs.steamPackages.steam-runtime-wrapped.overridePkgs
  ++ extraLibraries pkgs;

  extraInstallCommands = lib.optionalString (steam != null) ''
    mkdir -p $out/share/applications
    ln -s ${steam}/share/icons $out/share
    ln -s ${steam}/share/pixmaps $out/share
    ln -s ${steam}/share/applications/steam.desktop $out/share/applications/steam.desktop
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

    # udev event notifications don't work reliably inside containers.
    # SDL2 already tries to automatically detect flatpak and pressure-vessel
    # and falls back to inotify-based discovery [1]. We make SDL2 do the
    # same by telling it explicitly.
    #
    # [1] <https://github.com/libsdl-org/SDL/commit/8e2746cfb6e1f1a1da5088241a1440fd2535e321>
    export SDL_JOYSTICK_DISABLE_UDEV=1
  '' + extraProfile;

  runScript = writeShellScript "steam-wrapper.sh" ''
    if [ -f /host/etc/NIXOS ]; then   # Check only useful on NixOS
      ${glxinfo-i686}/bin/glxinfo >/dev/null 2>&1
      # If there was an error running glxinfo, we know something is wrong with the configuration
      if [ $? -ne 0 ]; then
        cat <<EOF > /dev/stderr
    **
    WARNING: Steam is not set up. Add the following options to /etc/nixos/configuration.nix
    and then run \`sudo nixos-rebuild switch\`:
    {
      hardware.graphics.enable32Bit = true;
      hardware.pulseaudio.support32Bit = true;
    }
    **
    EOF
      fi
    fi

    ${exportLDPath}
    ${fixBootstrap}

    set -o allexport # Export the following env vars
    ${envScript}
    exec steam ${extraArgs} "$@"
  '';

  inherit privateTmp;

  extraPreBwrapCmds = ''
    install -m 1777 -d /tmp/dumps
  '' + args.extraPreBwrapCmds or "";

  extraBwrapArgs = [
    "--bind-try /tmp/dumps /tmp/dumps"
  ] ++ args.extraBwrapArgs or [];

  meta =
    if steam != null
    then
      steam.meta // lib.optionalAttrs (!withGameSpecificLibraries) {
        description = steam.meta.description + " (without game specific libraries)";
        mainProgram = "steam";
      }
    else {
      description = "Steam dependencies (dummy package, do not use)";
    };

  passthru.steamargs = args;
  passthru.run = buildFHSEnv {
    name = "steam-run";

    targetPkgs = commonTargetPkgs;
    inherit multiArch multiPkgs profile extraInstallCommands extraBwrapArgs;

    runScript = writeShellScript "steam-run" ''
      run="$1"
      if [ "$run" = "" ]; then
        echo "Usage: steam-run command-to-run args..." >&2
        exit 1
      fi
      shift

      ${exportLDPath}
      ${fixBootstrap}

      set -o allexport # Export the following env vars
      ${envScript}
      exec -- "$run" "$@"
    '';

    meta = (steam.meta or {}) // {
      description = "Run commands in the same FHS environment that is used for Steam";
      mainProgram = "steam-run";
      name = "steam-run";
    };
  };
}
