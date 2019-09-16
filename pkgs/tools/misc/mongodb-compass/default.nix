{ stdenv, fetchurl, dpkg
, alsaLib, atk, cairo, cups, curl, dbus, expat, fontconfig, freetype, glib
, gnome2, gnome3, libnotify, libxcb, nspr, nss, systemd, xorg }:

let

  version = "1.17.0";

  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
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
    gnome2.gdk_pixbuf
    gnome3.gtk
    gnome2.pango
    libnotify
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
        sha256 = "085xq1ik8kyza1kq9kn0pf98zk6g2qa21clxhn48rgnqk20aninv";
      }
    else
      throw "MongoDB compass is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  pname = "mongodb-compass";
  inherit version;

  inherit src;

  buildInputs = [ dpkg ];
  dontUnpack = true;

  buildCommand = ''
    IFS=$'\n'
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/share/lintian
    #The node_modules are bringing in non-linux files/dependencies
    find $out -name "*.app" -exec rm -rf {} \; || true
    find $out -name "*.dll" -delete
    find $out -name "*.exe" -delete
    # Otherwise it looks "suspicious"
    chmod -R g-w $out
    for file in `find $out -type f -perm /0111 -o -name \*.so\*`; do
      echo "Manipulating file: $file"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/share/mongodb-compass "$file" || true
    done
  '';

  meta = with stdenv.lib; {
    description = "The GUI for MongoDB";
    homepage = https://www.mongodb.com/products/compass;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
