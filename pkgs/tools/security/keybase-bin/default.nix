{ stdenv, fetchurl, buildFHSUserEnv, writeTextFile, alsaLib, atk, cairo, cups
, dbus, expat, fontconfig, freetype, gcc, gdk_pixbuf, glib, gnome2, gtk2, nspr
, nss, pango, systemd, xorg, utillinuxMinimal }:

let
  libPath = stdenv.lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gcc.cc
    gdk_pixbuf
    glib
    gnome2.GConf
    gtk2
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
  ];
in
stdenv.mkDerivation rec {
  name = "keybase-bin-${version}";
  version = "1.0.35-20171110170110.68245d46b";
  src = fetchurl {
    url = "https://s3.amazonaws.com/prerelease.keybase.io/linux_binaries/deb/keybase_${version}_amd64.deb";
    sha256 = "1n7p0sf3b4h68x9kp2yasdy0qxw9bihlpl3r19lzp45dlnw5c289";
  };
  phases = ["unpackPhase" "installPhase" "fixupPhase"];
  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz
  '';
  installPhase = ''
    mkdir -p $out/share
    mv opt/keybase $out/share/
    mv usr/bin $out/
    substituteInPlace $out/bin/run_keybase --replace /opt/keybase $out/share/keybase
  '';
  postFixup = ''
    for i in \
      bin/git-remote-keybase \
      bin/kbfsfuse \
      bin/kbnm \
      bin/keybase \
      share/keybase/Keybase; do
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath "${libPath}:\$ORIGIN" "$out/$i"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official GUI, service, and file-system.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ np ];
  };
}
