{ stdenv, lib, gnome2, fetchurl, pkgs, xlibs, udev, makeWrapper, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "postman-${version}";
  version = "5.5.2";

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha1 = "68886197A8375E860AB880547838FEFC9E12FC64";
    name = "${name}.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontPatchELF = true;

  buildPhase = ":";   # nothing to build

  desktopItem = makeDesktopItem {
    name = "postman";
    exec = "postman";
    icon = "$out/share/postman/resources/app/assets/icon.png";
    comment = "API Development Environment";
    desktopName = "Postman";
    genericName = "Postman";
    categories = "Application;Development;";
  };

  installPhase = ''
    mkdir -p $out/share/postman
    mkdir -p $out/share/applications
    cp -R * $out/share/postman
    mkdir -p $out/bin
    ln -s $out/share/postman/Postman $out/bin/postman
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
      gnome2.pango
      gnome2.GConf
      pkgs.atk
      pkgs.alsaLib
      pkgs.cairo
      pkgs.cups
      pkgs.dbus_daemon.lib
      pkgs.expat
      pkgs.gdk_pixbuf
      pkgs.glib
      pkgs.gtk2-x11
      pkgs.freetype
      pkgs.fontconfig
      pkgs.nss
      pkgs.nspr
      pkgs.udev.lib
      xlibs.libX11
      xlibs.libxcb
      xlibs.libXi
      xlibs.libXcursor
      xlibs.libXdamage
      xlibs.libXrandr
      xlibs.libXcomposite
      xlibs.libXext
      xlibs.libXfixes
      xlibs.libXrender
      xlibs.libX11
      xlibs.libXtst
      xlibs.libXScrnSaver
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:$out/share/postman" \
      $out/share/postman/Postman
    patchelf --set-rpath "${libPath}" $out/share/postman/libnode.so
    patchelf --set-rpath "${libPath}" $out/share/postman/libffmpeg.so

    wrapProgram $out/share/postman/Postman --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.getpostman.com;
    description = "API Development Environment";
    license = stdenv.lib.licenses.postman;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ xurei ];
  };
}
