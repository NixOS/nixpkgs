{ buildFHSEnv
, heroic-unwrapped
, extraPkgs ? pkgs: [ ]
, extraLibraries ? pkgs: [ ]
}:

buildFHSEnv {
  name = "heroic";

  runScript = "heroic";

  # Many Wine and native games need 32-bit libraries.
  multiArch = true;

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
    libgudev
    libjpeg
    libkrb5
    libmpeg2
    libogg
    libopus
    libpng
    libpulseaudio
    libselinux
    libsndfile
    libsoup
    libtheora
    libtiff
    libusb1
    libv4l
    libva
    libvdpau
    libvorbis
    libvpx
    libwebp
    libxkbcommon
    libxml2
    mpg123
    ncurses
    ocl-icd
    openal
    openldap
    openssl
    pango
    pipewire
    samba4
    sane-backends
    SDL2
    speex
    sqlite
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
