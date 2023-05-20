{ buildFHSUserEnvBubblewrap
, stdenv
, lib
, writeShellScript
, xorg
, curl
, libdrm
, openssl
, zlib
, dotnet-sdk_3
, lttng-ust
, krb5Full
, vulkan-loader
, vulkan-tools
, vulkan-extension-layer
, vulkan-validation-layers
, linuxPackages
, libGL
, mesa
, xdg-user-dirs
, pkg-config
, git
, python2
, mono
, libgcc
, cmake
, udev
, SDL2
, dbus
, alsaLib
, pango
, nspr
, atk
, atkmm
, at-spi2-atk
, nss
, glib
, cairo
, gobject-introspection
, expat
, gio-sharp
, at-spi2-core
, ue5-unwrapped
, bashInteractive
, ... }:

let
  libPath = lib.makeLibraryPath [
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXau
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXxf86vm
    xorg.libxcb
    openssl
  ];
  common = [
    libdrm

    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXcursor
    xorg.libXtst
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXcomposite
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    curl
    xorg.libXxf86vm
    xorg.libXdamage
    zlib
    dotnet-sdk_3
    lttng-ust
    krb5Full

    vulkan-loader
    vulkan-tools
    vulkan-extension-layer
    vulkan-validation-layers
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath([
    stdenv.cc.cc.lib
  ] ++ common);
in buildFHSUserEnvBubblewrap {
  name = "UnrealEditor";

  # Adapted from Steam wrapper
  extraBuildCommands = ''
    if [ -f $out/usr/share/vulkan/icd.d/nvidia_icd.json ]; then
      cp $out/usr/share/vulkan/icd.d/nvidia_icd{,32}.json
      nvidia32Lib=$(realpath $out/lib32/libGLX_nvidia.so.0 | cut -d'/' -f-4)
      escapedNvidia32Lib="''${nvidia32Lib//\//\\\/}"
      sed -i "s/\/nix\/store\/.*\/lib\/libGLX_nvidia\.so\.0/$escapedNvidia32Lib\/lib\/libGLX_nvidia\.so\.0/g" $out/usr/share/vulkan/icd.d/nvidia_icd32.json
    fi
  '';

  # Adapated from Steam wrapper
  runScript = "${writeShellScript "run-ue5" ''
    export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    export UE_USE_SYSTEM_MONO=1
    export UE_USE_SYSTEM_DOTNET=1
    export DOTNET_ROOT=$(dirname $(realpath $(which dotnet)))
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

    sharedir="${ue5-unwrapped}"

    workdir="$HOME/.config/unreal-engine-nix-workdir"
    if [ ! -e "$workdir" ]; then
      mkdir -p "$workdir"
      ${xorg.lndir}/bin/lndir "$sharedir" "$workdir"
      unlink "$workdir/Engine/Binaries/Linux/UnrealEditor"
      cp "$sharedir/Engine/Binaries/Linux/UnrealEditor" "$workdir/Engine/Binaries/Linux/UnrealEditor"
    fi

    cd "$workdir/Engine/Binaries/Linux"
    export PATH="${xdg-user-dirs}/bin''${PATH:+:}$PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${LD_LIBRARY_PATH}:$workdir/Engine/Binaries/Linux:$workdir/Engine/Binaries/ThirdParty/nvTextureTools/Linux/x86_64-unknown-linux-gnu/"
    exec ./UnrealEditor "$@"
  ''}";

  unshareIpc = false;
  unsharePid = false;

  targetPkgs = pkgs: with pkgs; [
    dotnet-sdk_3
    pkg-config
    coreutils
    which
    git
    python2
    mono
    libgcc
    cmake
    udev
    SDL2.dev
    dbus
    alsaLib
    pango
    nspr
    atk
    atkmm
    at-spi2-atk
    nss
    glib
    cairo
    gobject-introspection
    expat
    gio-sharp
    at-spi2-core
    vulkan-tools
    vulkan-extension-layer
    vulkan-validation-layers
    openssl
    mesa
  ];

  multiPkgs = pkgs: with pkgs; [
    linuxPackages.nvidia_x11_beta
    vulkan-loader
    libGL
    mesa.drivers
  ];
}
