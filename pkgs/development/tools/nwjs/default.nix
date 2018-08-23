{ stdenv, fetchurl, buildEnv, makeWrapper

, xorg, alsaLib, dbus, glib, gtk3, atk, pango, freetype, fontconfig
, gdk_pixbuf, cairo, nss, nspr, gconf, expat, systemd, libcap
, libnotify
, ffmpeg, libxcb, cups
, sqlite, udev
}:
let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = [
      xorg.libX11 xorg.libXrender glib /*gtk2*/ gtk3 atk pango cairo gdk_pixbuf
      freetype fontconfig xorg.libXcomposite alsaLib xorg.libXdamage
      xorg.libXext xorg.libXfixes nss nspr gconf expat dbus
      xorg.libXtst xorg.libXi xorg.libXcursor xorg.libXrandr
      xorg.libXScrnSaver cups
      libcap libnotify
      # libnw-specific (not chromium dependencies)
      ffmpeg libxcb
      # chromium runtime deps (dlopen’d)
      sqlite udev
    ];

    extraOutputsToInstall = [ "lib" "out" ];
  };

in stdenv.mkDerivation rec {
  name = "nwjs-${version}";
  version = "0.32.2";

  src = fetchurl {
    url = "https://dl.nwjs.io/v${version}/nwjs-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "0f0p17mbr24zhzm2cf77ddy6yj4k0k181dzf4gxdf8szd5vxpliy" else
      "0a3b712abfa0c3e7e808b1d08ea5d53375a71060e7d144fdcb58c4fe88fa2250";
  };

  phases = [ "unpackPhase" "installPhase" ];

  # we have runtime deps like sqlite3 that should remain
  dontPatchELF = true;

  installPhase =
    let ccPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];
    in ''
      mkdir -p $out/share/nwjs
      cp -R * $out/share/nwjs
      find $out/share/nwjs

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/nwjs/nw

      ln -s ${systemd.lib}/lib/libudev.so $out/share/nwjs/libudev.so.0

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
  '';

  buildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = https://nwjs.io/;
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
