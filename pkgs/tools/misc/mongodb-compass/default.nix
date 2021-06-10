{ lib, stdenv, fetchurl, dpkg
, alsa-lib, at-spi2-atk, at-spi2-core, atk, cairo, cups, curl, dbus, expat, fontconfig, freetype, glib
, gnome2, gdk-pixbuf, gtk3, pango, libnotify, libsecret, libuuid, libxcb, nspr, nss, systemd, xorg, wrapGAppsHook }:

let
  version = "1.25.0";

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    gnome2.GConf
    gdk-pixbuf
    gtk3
    pango
    libnotify
    libsecret
    libuuid
    libxcb
    nspr
    nss
    stdenv.cc.cc
    systemd

    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://downloads.mongodb.com/compass/mongodb-compass_${version}_amd64.deb";
        sha256 = "sha256-998/voQ04fLj3KZCy6BueUoI1v++4BoGRTGJT7Nsv40=";
      }
    else
      throw "MongoDB compass is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  pname = "mongodb-compass";
  inherit version;

  inherit src;

  buildInputs = [ dpkg wrapGAppsHook gtk3 ];
  dontUnpack = true;

  buildCommand = ''
    IFS=$'\n'

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract

    mkdir -p $out
    mv usr/* $out

    # cp -av $out/usr/* $out
    rm -rf $out/share/lintian

    # The node_modules are bringing in non-linux files/dependencies
    find $out -name "*.app" -exec rm -rf {} \; || true
    find $out -name "*.dll" -delete
    find $out -name "*.exe" -delete

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in `find $out -type f -perm /0111 -o -name \*.so\*`; do
      echo "Manipulating file: $file"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/mongodb-compass "$file" || true
    done

    wrapGAppsHook $out/bin/mongodb-compass
  '';

  meta = with lib; {
    description = "The GUI for MongoDB";
    homepage = "https://www.mongodb.com/products/compass";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
