{ stdenv, makeWrapper, fetchurl, dpkg, alsaLib, atk, cairo, cups, dbus, expat
, fontconfig, freetype, gdk-pixbuf, glib, gnome2, nspr, nss, gtk3, gtk2
, at-spi2-atk, gsettings-desktop-schemas, gobject-introspection, wrapGAppsHook
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, nghttp2
, libudev0-shim, glibc, curl, openssl, autoPatchelfHook }:

let
  runtimeLibs = stdenv.lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    nghttp2
    openssl
    stdenv.cc.cc
  ];
in stdenv.mkDerivation rec {
  pname = "insomnia-designer";
  version = "2020.2.2";

  src = fetchurl {
    url =
      "https://github.com/Kong/insomnia/releases/download/designer@${version}/Insomnia.Designer-${version}.deb";
    sha256 = "0hqhfwsvdz1jcza05prjvr5md5bdd2w0zffg5wh0bsvmsv6p1nq7";
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
    gnome2.pango
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
    mkdir -p $out/share/insomnia $out/lib $out/bin

    mv usr/share/* $out/share/
    mv opt/Insomnia\ Designer/* $out/share/insomnia
    mv $out/share/insomnia/*.so $out/lib/

    ln -s $out/share/insomnia/designer $out/bin/designer
    sed -i 's|\/opt\/Insomnia Designer|'$out'/bin|g' $out/share/applications/designer.desktop
  '';

  preFixup = ''
    wrapProgram "$out/bin/designer" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';

  meta = with stdenv.lib; {
    homepage = "https://insomnia.rest/";
    description = "The most intuitive cross-platform REST API Client";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markus1189 babariviere ];
  };

}
