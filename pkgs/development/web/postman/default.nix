{ stdenv, fetchurl, makeDesktopItem, wrapGAppsHook
, atk, at-spi2-atk, alsaLib, cairo, cups, dbus, expat, gdk-pixbuf, glib, gtk3
, freetype, fontconfig, nss, nspr, pango, udev, libX11, libxcb, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite, libXext, libXfixes
, libXrender, libXtst, libXScrnSaver
}:

stdenv.mkDerivation rec {
  pname = "postman";
  version = "7.16.0";

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha256 = "1f68z4n0n2jj5ymssii82cswz4kw3dd3zkz26ahsbpsc2hr7ijxp";
    name = "${pname}.tar.gz";
  };

  dontBuild = true; # nothing to build
  dontConfigure = true;

  desktopItem = makeDesktopItem {
    name = "postman";
    exec = "postman";
    icon = "postman";
    comment = "API Development Environment";
    desktopName = "Postman";
    genericName = "Postman";
    categories = "Application;Development;";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    atk
    at-spi2-atk
    alsaLib
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    freetype
    fontconfig
    nss
    nspr
    pango
    udev
    libX11
    libxcb
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libXtst
    libXScrnSaver
  ];

  nativeBuildInputs = [ wrapGAppsHook ];


  installPhase = ''
    mkdir -p $out/share/postman
    cp -R app/* $out/share/postman
    rm $out/share/postman/Postman

    mkdir -p $out/bin
    ln -s $out/share/postman/_Postman $out/bin/postman

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    iconRootDir=$out/share/icons
    iconSizeDir=$out/share/icons/hicolor/128x128/apps
    mkdir -p $iconSizeDir
    ln -s $out/share/postman/resources/app/assets/icon.png $iconRootDir/postman.png
    ln -s $out/share/postman/resources/app/assets/icon.png $iconSizeDir/postman.png
  '';

  postFixup = ''
    pushd $out/share/postman
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" _Postman
    for file in $(find . -type f \( -name \*.node -o -name _Postman -o -name \*.so\* \) ); do
      ORIGIN=$(patchelf --print-rpath $file); \
      patchelf --set-rpath "${stdenv.lib.makeLibraryPath buildInputs}:$ORIGIN" $file
    done
    popd
  '';

  meta = with stdenv.lib; {
    homepage = https://www.getpostman.com;
    description = "API Development Environment";
    license = licenses.postman;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ xurei evanjs ];
  };
}
