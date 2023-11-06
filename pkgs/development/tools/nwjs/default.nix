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

in
stdenv.mkDerivation rec {
  pname = "nwjs";
  version = "0.82.0";

  src =
    let flavor = if sdk then "sdk-" else "";
    in fetchurl {
      url = "https://dl.nwjs.io/v${version}/nwjs-${flavor}v${version}-linux-${bits}.tar.gz";
      hash = {
        "sdk-ia32" = "sha256-aIRnZDslOhoD5F0coX43VNFWGEImPU5oq9Roc4jYfsY=";
        "sdk-x64" = "sha256-rKbnNAq9AVjSUjTipYze2VHiVi0RnZZsdQj1725DPd0=";
        "ia32" = "sha256-pA53+A+EtS7m6026jPlC3vFxb2iheS4peDJFNkQAf/s=";
        "x64" = "sha256-hRih8o8hBbYBEes3Z62PSMIC720SLRa3t2rL/5LaJAE=";
      }."${flavor + bits}";
    };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];
  runtimeDependencies = [ sqlite libuuid udev ];

  installPhase =
    let ccPath = lib.makeLibraryPath [ stdenv.cc.cc ];
    in
    ''
      mkdir -p $out/share/nwjs
      cp -R * $out/share/nwjs
      find $out/share/nwjs

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/nwjs/nw

      ln -s ${lib.getLib systemd}/lib/libudev.so $out/share/nwjs/libudev.so.0

      libpath="$out/share/nwjs/lib/"
      for f in "$libpath"/*.so; do
        patchelf --set-rpath "${nwEnv}/lib:${ccPath}:$libpath" "$f"
      done
      patchelf --set-rpath "${nwEnv}/lib:${nwEnv}/lib64:${ccPath}:$libpath" $out/share/nwjs/nw
      # check, whether all RPATHs are correct (all dependencies found)
      checkfile=$(mktemp)
      for f in "$libpath"/*.so "$out/share/nwjs/nw"; do
         (echo "$f:";
          ldd "$f"  ) > "$checkfile"
      done
      if <"$checkfile" grep -e "not found"; then
        cat "$checkfile"
        exit 1
      fi

      mkdir -p $out/bin
      ln -s $out/share/nwjs/nw $out/bin

      mkdir $out/lib
      ln -s $out/share/nwjs/lib/libnw.so $out/lib/libnw.so
    '';

  meta = with lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
