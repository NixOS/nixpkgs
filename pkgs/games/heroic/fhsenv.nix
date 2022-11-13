{ lib
, buildFHSUserEnv
, heroic-unwrapped
, extraPkgs ? pkgs: [ ]
, extraLibraries ? pkgs: [ ]
}:

buildFHSUserEnv {
  name = "heroic";

  runScript = "heroic";

  targetPkgs = pkgs: with pkgs; [
    heroic-unwrapped
    gamemode
    curl
    gawk
    gnome.zenity
    plasma5Packages.kdialog
    mangohud
    nettools
    opencl-headers
    p7zip
    perl
    psmisc
    python3
    which
    xorg.xrandr
    zstd
  ] ++ extraPkgs pkgs;

  multiPkgs = let
    xorgDeps = pkgs: with pkgs.xorg; [
      libpthreadstubs
      libSM
      libX11
      libXaw
      libxcb
      libXcomposite
      libXcursor
      libXdmcp
      libXext
      libXi
      libXinerama
      libXmu
      libXrandr
      libXrender
      libXv
      libXxf86vm
    ];
  in pkgs: with pkgs; [
    alsa-lib
    alsa-plugins
    bash
    cabextract
    cairo
    coreutils
    cups
    dbus
    freealut
    freetype
    fribidi
    giflib
    glib
    gnutls
    gst_all_1.gst-plugins-base
    gtk3
    lcms2
    libevdev
    libgcrypt
    libGLU
    libglvnd
    libgpg-error
    libjpeg
    libkrb5
    libmpeg2
    libogg
    libopus
    libpng
    libpulseaudio
    libselinux
    libsndfile
    libsndfile
    libtheora
    libtiff
    libusb1
    libv4l
    libva
    libvorbis
    libxkbcommon
    libxml2
    mpg123
    ncurses
    ocl-icd
    openldap
    pipewire
    samba4
    sane-backends
    SDL2
    sqlite
    udev
    udev
    unixODBC
    util-linux
    v4l-utils
    vulkan-loader
    wayland
    zlib
  ] ++ xorgDeps pkgs
    ++ extraLibraries pkgs;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${heroic-unwrapped}/share/applications $out/share
    ln -s ${heroic-unwrapped}/share/icons $out/share
  '';

  meta = heroic-unwrapped.meta;
}
