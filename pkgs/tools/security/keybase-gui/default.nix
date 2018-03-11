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
  name = "keybase-gui-${version}";
  version = "1.0.44-20180223200436.9a9ccec79";
  src = fetchurl {
    url = "https://s3.amazonaws.com/prerelease.keybase.io/linux_binaries/deb/keybase_${version}_amd64.deb";
    sha256 = "0dmi0fw39924kpahlsk853hbmpy8a6nj78lrh1wharayjpvj6jv3";
  };
  phases = ["unpackPhase" "installPhase" "fixupPhase"];
  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv usr/share $out/share
    mv opt/keybase $out/share/

    cat > $out/bin/keybase-gui <<EOF
    #!${stdenv.shell}

    checkFailed() {
      if [ "\$NIX_SKIP_KEYBASE_CHECKS" = "1" ]; then
        return
      fi
      echo "Set NIX_SKIP_KEYBASE_CHECKS=1 if you want to skip this check." >&2
      exit 1
    }

    if [ ! -S "\$XDG_RUNTIME_DIR/keybase/keybased.sock" ]; then
      echo "Keybase service doesn't seem to be running." >&2
      echo "You might need to run: keybase service" >&2
      checkFailed
    fi

    ${utillinuxMinimal}/bin/mountpoint /keybase &>/dev/null
    if [ "\$?" -ne "0" ]; then
      echo "Keybase is not mounted to /keybase." >&2
      echo "You might need to run: kbfsfuse /keybase" >&2
      checkFailed
    fi

    exec $out/share/keybase/Keybase "\$@"
    EOF
    chmod +x $out/bin/keybase-gui

    substituteInPlace $out/share/applications/keybase.desktop \
      --replace run_keybase $out/bin/keybase-gui
  '';
  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath "${libPath}:\$ORIGIN" "$out/share/keybase/Keybase"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official GUI.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh np ];
  };
}
