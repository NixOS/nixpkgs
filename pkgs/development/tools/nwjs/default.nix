{ stdenv, lib, fetchurl, buildEnv, makeWrapper, autoPatchelfHook

, xorg, alsa-lib, at-spi2-core, dbus, glib, gtk3, atk, pango, freetype
, fontconfig , gdk-pixbuf, cairo, mesa, nss, nspr, expat, systemd
, libcap, libdrm, libxkbcommon
, libnotify
, ffmpeg, libxcb, cups
, sqlite, udev
, libuuid
, sdk ? false
}:
let
  bits = if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
         else "ia32";

  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = [
      xorg.libX11 xorg.libXrender glib gtk3 atk at-spi2-core pango cairo gdk-pixbuf
      freetype fontconfig xorg.libXcomposite alsa-lib xorg.libXdamage
      xorg.libXext xorg.libXfixes mesa nss nspr expat dbus
      xorg.libXtst xorg.libXi xorg.libXcursor xorg.libXrandr
      xorg.libXScrnSaver xorg.libxshmfence cups
      libcap libdrm libnotify
      libxkbcommon
      # libnw-specific (not chromium dependencies)
      ffmpeg libxcb
      # chromium runtime deps (dlopen’d)
      sqlite udev
      libuuid
    ];

    extraOutputsToInstall = [ "lib" "out" ];
  };

in stdenv.mkDerivation rec {
  pname = "nwjs";
  version = "0.82.0";

  src = if sdk then fetchurl {
    url = "https://dl.nwjs.io/v${version}/nwjs-sdk-v${version}-linux-${bits}.tar.gz";
    hash = if bits == "x64" then
      "sha256-rKbnNAq9AVjSUjTipYze2VHiVi0RnZZsdQj1725DPd0=" else
      "sha256-aIRnZDslOhoD5F0coX43VNFWGEImPU5oq9Roc4jYfsY=";
  } else fetchurl {
    url = "https://dl.nwjs.io/v${version}/nwjs-v${version}-linux-${bits}.tar.gz";
    hash = if bits == "x64" then
      "sha256-aIRnZDslOhoD5F0coX43VNFWGEImPU5oq9Roc4jYfsY=" else
      "sha256-pA53+A+EtS7m6026jPlC3vFxb2iheS4peDJFNkQAf/s=";
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];
  runtimeDependencies = [ sqlite libuuid udev ];

  installPhase =
    let ccPath = lib.makeLibraryPath [ stdenv.cc.cc ];
    in ''
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
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
