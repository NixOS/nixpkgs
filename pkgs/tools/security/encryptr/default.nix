{ stdenv, lib, fetchurl, glib, nss, nspr, gconf, fontconfig, freetype
, pango , cairo, libX11 , libXi, libXcursor, libXext, libXfixes
, libXrender, libXcomposite , alsaLib, libXdamage, libXtst, libXrandr
, expat, libcap, systemd , dbus, gtk2 , gdk-pixbuf, libnotify
}:

let
  arch = if stdenv.hostPlatform.system == "x86_64-linux" then "amd"
    else if stdenv.hostPlatform.system == "i686-linux" then "i386"
    else throw "Encryptr for ${stdenv.hostPlatform.system} not supported!";

  sha256 = if stdenv.hostPlatform.system == "x86_64-linux" then "1j3g467g7ar86hpnh6q9mf7mh2h4ia94mwhk1283zh739s2g53q2"
    else if stdenv.hostPlatform.system == "i686-linux" then "02j9hg9b1jlv25q1sjfhv8d46mii33f94dj0ccn83z9z18q4y2cm"
    else throw "Encryptr for ${stdenv.hostPlatform.system} not supported!";

in stdenv.mkDerivation rec {
  pname = "encryptr";
  version = "2.0.0";

  src = fetchurl {
    url = "https://spideroak.com/dist/encryptr/signed/linux/targz/encryptr-${version}_${arch}.tar.gz";
    inherit sha256;
  };

  dontBuild = true;

  rpath = lib.makeLibraryPath [
    glib nss nspr gconf fontconfig freetype pango cairo libX11 libXi
    libXcursor libXext libXfixes libXrender libXcomposite alsaLib
    libXdamage libXtst libXrandr expat libcap dbus gtk2 gdk-pixbuf
    libnotify stdenv.cc.cc
  ];

  installPhase = ''
    mkdir -pv $out/bin $out/lib
    cp -v {encryptr-bin,icudtl.dat,nw.pak} $out/bin
    mv -v $out/bin/encryptr{-bin,}
    cp -v lib* $out/lib
    ln -sv ${lib.getLib systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath $out/lib:${rpath} \
             $out/bin/encryptr
  '';

  # If stripping, node-webkit does not find
  # its application and shows a generic page
  dontStrip = true;

  meta = with lib; {
    homepage = "https://spideroak.com/solutions/encryptr";
    description = "Free, private and secure password management tool and e-wallet";
    license = licenses.unfree;
    maintainers = with maintainers; [ guillaumekoenig ];
    platforms = platforms.linux;
  };
}
