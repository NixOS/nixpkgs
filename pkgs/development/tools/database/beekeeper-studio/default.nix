{ lib, stdenv, makeWrapper, fetchurl, dpkg, alsaLib, atk, cairo, cups, dbus, expat
, fontconfig, freetype, gdk-pixbuf, glib, gnome2, pango, nspr, nss, gtk3, gtk2
, at-spi2-atk, gsettings-desktop-schemas, gobject-introspection, wrapGAppsHook
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, nghttp2
, libudev0-shim, glibc, curl, openssl, autoPatchelfHook }:

let
  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    nghttp2
    openssl
    stdenv.cc.cc
  ];
in stdenv.mkDerivation rec {
  pname = "beekeeper-studio";
  version = "1.10.2";

  src = fetchurl {
    url =
      "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/beekeeper-studio_${version}_amd64.deb";
    sha256 = "5ada21ded5afd15a9fde1d02a0fe150bd4bba4b3d5cb0cbc533fe4ea1049c720";
  };

  nativeBuildInputs =
    [ autoPatchelfHook dpkg makeWrapper gobject-introspection wrapGAppsHook ];

  buildInputs = [
    alsaLib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    pango
    gtk2
    gtk3
    gsettings-desktop-schemas
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    nspr
    nss
    stdenv.cc.cc
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/share/beekeeper-studio $out/lib $out/bin

    mv usr/share/* $out/share/
    mv opt/Beekeeper\ Studio/* $out/share/beekeeper-studio/
    mv $out/share/beekeeper-studio/*.so $out/lib/

    ln -s $out/share/beekeeper-studio/beekeeper-studio-bin $out/bin/beekeeper-studio
    sed -i 's|\/opt\/Beekeeper Studio|'$out'/bin|g' $out/share/applications/beekeeper-studio.desktop
  '';

  preFixup = ''
    wrapProgram "$out/bin/beekeeper-studio" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';

  meta = with lib; {
    homepage = "https://www.beekeeperstudio.io/";
    description = "Open Source SQL Editor and Database Manager";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Mdsp9070 ];
  };

}
