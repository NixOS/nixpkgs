{ stdenv, lib, makeWrapper, fetchurl,
  alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk-pixbuf, glib,
  gnome2, gtk2-x11, nspr, nss,
  libX11, libxcb, libXcomposite, libXcursor, libXdamage, libXext, libXfixes,
  libXi, libXrandr, libXrender, libXScrnSaver, libXtst,
  libudev0-shim
}:
  stdenv.mkDerivation rec {
    pname = "sweep-visualizer";
    version = "0.15.0";

    src = fetchurl {
      url = "https://s3.amazonaws.com/scanse/Visualizer/v${version}/sweepvisualizer_${version}_amd64.deb";
      sha256 = "1k6rdjw2340qrzafv6hjxvbvyh3s1wad6d3629nchdcrpyx9xy1c";
    };

    nativeBuildInputs = [ makeWrapper ];

    sourceRoot = ".";
    unpackCmd = ''
      ar p "$src" data.tar.xz | tar xJ
    '';

    buildPhase = ":";

    installPhase = ''
      mkdir -p $out/bin $out/share/sweep-visualizer
      mv usr/share/* $out/share
      mv opt/Sweep\ Visualizer\ BETA/* $out/share/sweep-visualizer/
      ln -s $out/share/sweep-visualizer/sweep_visualizer $out/bin/sweep_visualizer
    '';

    preFixup = let
      libPath = lib.makeLibraryPath [
        alsaLib atk cairo cups.lib dbus.lib expat fontconfig.lib freetype
        gdk-pixbuf glib gnome2.GConf gnome2.pango gtk2-x11 nspr nss stdenv.cc.cc.lib
        libX11 libxcb libXcomposite libXcursor libXdamage libXext libXfixes
        libXi libXrandr libXrender libXScrnSaver libXtst
      ];
      runtimeLibs = lib.makeLibraryPath [ libudev0-shim ];
    in ''
      for lib in $out/share/sweep-visualizer/*.so; do
        patchelf --set-rpath "$out/share/sweep-visualizer:${libPath}" $lib
      done
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$out/share/sweep-visualizer:${libPath}" \
        $out/share/sweep-visualizer/sweep_visualizer
      wrapProgram "$out/bin/sweep_visualizer" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
    '';

    meta = with stdenv.lib; {
      homepage = "https://support.scanse.io/hc/en-us/articles/115006008948-Visualizer-Overview";
      description = "A minimal desktop application for interfacing with the Sweep device";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ mt-caret ];
    };
  }
