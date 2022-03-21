{ lib, stdenv, makeWrapper, fetchurl, dpkg, alsa-lib, atk, cairo, cups, dbus, expat
, fontconfig, freetype, gdk-pixbuf, glib, pango, mesa, nspr, nss, gtk3
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
  ];
in stdenv.mkDerivation rec {
  pname = "insomnia";
  version = "2021.7.2";

  src = fetchurl {
    url =
      "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.deb";
    sha256 = "sha256-HkQWW4h2+XT5Xi4oiIiMPnrRKw+GIyjGMQ5B1NrBARU=";
  };

  nativeBuildInputs =
    [ autoPatchelfHook dpkg makeWrapper gobject-introspection wrapGAppsHook ];

  buildInputs = [
    alsa-lib
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
    pango
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
    mesa # for libgbm
    nspr
    nss
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/share/insomnia $out/lib $out/bin

    mv usr/share/* $out/share/
    mv opt/Insomnia/* $out/share/insomnia
    mv $out/share/insomnia/*.so $out/lib/

    ln -s $out/share/insomnia/insomnia $out/bin/insomnia
    sed -i 's|\/opt\/Insomnia|'$out'/bin|g' $out/share/applications/insomnia.desktop
  '';

  preFixup = ''
    wrapProgram "$out/bin/insomnia" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';

  meta = with lib; {
    homepage = "https://insomnia.rest/";
    description = "The most intuitive cross-platform REST API Client";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markus1189 babariviere ];
  };

}
