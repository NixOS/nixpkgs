with import <nixpkgs> { };

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
    # version = "1.0.25-20170714172717.73f9070";
    version = with builtins; replaceStrings ["+"] ["."] (fromJSON (readFile (fetchurl "http://prerelease.keybase.io.s3.amazonaws.com/update-linux-prod.json"))).version;
    src = builtins.fetchurl "https://s3.amazonaws.com/prerelease.keybase.io/linux_binaries/deb/keybase_${version}_amd64.deb";
    phases = ["unpackPhase" "installPhase" "fixupPhase"];
    unpackPhase = ''
      ar xf $src
      tar xf data.tar.xz
    '';
    installPhase = ''
      mkdir -p $out/{bin,share/keybase}

      substitute usr/bin/run_keybase $out/bin/run_keybase --replace /opt $out/share
      rm usr/bin/run_keybase
      chmod +x $out/bin/run_keybase

      mv usr/bin/* $out/bin/
      mv opt/keybase/* $out/share/keybase/
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
