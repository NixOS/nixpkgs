{ stdenv, lib, gnome2, fetchurl, pkgs, xorg, udev, makeWrapper, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "postman-${version}";
  version = "5.5.3";

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha1 = "BC0C6117BEC6D1638FD18A0E2A580617669A9297";
    name = "${name}.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontPatchELF = true;

  buildPhase = ":";   # nothing to build

  icon = fetchurl {
    url = "https://www.getpostman.com/img-rebrand/logo.png";
    sha256 = "0jdhl9c07b1723j2f172z3s5p5lh8sqa1rcvdzz3h6z5zwn21g7v";
  };

  desktopItem = makeDesktopItem {
    name = "postman";
    exec = "postman";
    icon = "${icon}";
    comment = "API Development Environment";
    desktopName = "Postman";
    genericName = "Postman";
    categories = "Application;Development;";
  };

  installPhase = ''
    mkdir -p $out/share/postman
    cp -R * $out/share/postman

    mkdir -p $out/bin
    ln -s $out/share/postman/Postman $out/bin/postman

    mkdir -p $out/share/applications
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
      xorg.libX11
      xorg.libxcb
      xorg.libXi
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libXext
      xorg.libXfixes
      xorg.libXrender
      xorg.libX11
      xorg.libXtst
      xorg.libXScrnSaver
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
