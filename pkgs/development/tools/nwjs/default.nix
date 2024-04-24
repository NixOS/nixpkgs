{ alsa-lib
, at-spi2-core
, atk
, autoPatchelfHook
, buildEnv
, cairo
, cups
, dbus
, expat
, fetchurl
, ffmpeg
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, lib
, libcap
, libdrm
, libnotify
, libuuid
, libxcb
, libxkbcommon
, makeWrapper
, mesa
, nspr
, nss
, pango
, sdk ? false
, sqlite
, stdenv
, systemd
, udev
, wrapGAppsHook
, xorg
}:

let
  bits = if stdenv.hostPlatform.system == "x86_64-linux" then "x64" else "ia32";

  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = [
      alsa-lib
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libcap
      libdrm
      libnotify
      libxkbcommon
      mesa
      nspr
      nss
      pango
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxshmfence
      # libnw-specific (not chromium dependencies)
      ffmpeg
      libxcb
      # chromium runtime deps (dlopen’d)
      libuuid
      sqlite
      udev
    ];

    extraOutputsToInstall = [ "lib" "out" ];
  };

  version = "0.85.0";
in
stdenv.mkDerivation {
  pname = "nwjs";
  inherit version;

  src =
    let flavor = if sdk then "sdk-" else "";
    in fetchurl {
      url = "https://dl.nwjs.io/v${version}/nwjs-${flavor}v${version}-linux-${bits}.tar.gz";
      hash = {
        "sdk-ia32" = "sha256-QcFKX+TLRBYAMt5oUYoVMfBgGFZZ/4pdhhtNI0OxF/M=";
        "sdk-x64" = "sha256-Wqq0iI5VLa/hJLTNF10YpFTtLRP6okjCC2EzlXxeuWI=";
        "ia32" = "sha256-st/J/Zejo3R0dKxxdM7XBvmAlfsO2+2i5lYlAv9A5lY=";
        "x64" = "sha256-hxSyzNEH6UJVejUqoG01vpJxb319wrLgp7uyF6Pt5YQ=";
      }."${flavor + bits}";
    };

  nativeBuildInputs = [
    autoPatchelfHook
    (wrapGAppsHook.override { inherit makeWrapper; })
  ];

  buildInputs = [ nwEnv ];
  appendRunpaths = map (pkg: (lib.getLib pkg) + "/lib") [ nwEnv stdenv.cc.libc stdenv.cc.cc ];

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    )
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/share/nwjs
      cp -R * $out/share/nwjs
      find $out/share/nwjs

      ln -s ${lib.getLib systemd}/lib/libudev.so $out/share/nwjs/libudev.so.0

      mkdir -p $out/bin
      ln -s $out/share/nwjs/nw $out/bin

      mkdir $out/lib
      ln -s $out/share/nwjs/lib/libnw.so $out/lib/libnw.so

      runHook postInstall
    '';

  meta = with lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ maintainers.mikaelfangel ];
    mainProgram = "nw";
    license = licenses.bsd3;
  };
}
