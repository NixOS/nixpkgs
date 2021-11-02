{ stdenv, lib, fetchurl, buildEnv, makeWrapper

, xorg, alsa-lib, dbus, glib, gtk3, atk, pango, freetype, fontconfig
, gdk-pixbuf, cairo, nss, nspr, gconf, expat, systemd, libcap
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
      xorg.libX11 xorg.libXrender glib /*gtk2*/ gtk3 atk pango cairo gdk-pixbuf
      freetype fontconfig xorg.libXcomposite alsa-lib xorg.libXdamage
      xorg.libXext xorg.libXfixes nss nspr gconf expat dbus
      xorg.libXtst xorg.libXi xorg.libXcursor xorg.libXrandr
      xorg.libXScrnSaver cups
      libcap libnotify
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
  version = "0.33.4";

  src = if sdk then fetchurl {
    url = "https://dl.nwjs.io/v${version}/nwjs-sdk-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "1hi6xispxvyb6krm5j11mv8509dwpw5ikpbkvq135gsk3gm29c9y" else
      "00p4clbfinrj5gp2i84a263l3h00z8g7mnx61qwmr0z02kvswz9s";
  } else fetchurl {
    url = "https://dl.nwjs.io/v${version}/nwjs-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "09zd6gja3l20xx03h2gawpmh9f8nxqjp8qdkds5nz9kbbckhkj52" else
      "0nlpdz76k1p1pq4xygfr2an91m0d7p5fjyg2xhiggyy8b7sp4964";
  };

  # we have runtime deps like sqlite3 that should remain
  dontPatchELF = true;

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

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
