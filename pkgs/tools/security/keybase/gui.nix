{ stdenv, fetchurl, alsaLib, atk, cairo, cups, udev, hicolor-icon-theme
, dbus, expat, fontconfig, freetype, gdk_pixbuf, glib, gtk3, gnome3
, libnotify, nspr, nss, pango, systemd, xorg, autoPatchelfHook, wrapGAppsHook }:

let
  versionSuffix = "20190205202117.6394d03e6c";
in

stdenv.mkDerivation rec {
  name = "keybase-gui-${version}";
  version = "3.0.0"; # Find latest version from https://prerelease.keybase.io/deb/dists/stable/main/binary-amd64/Packages

  src = fetchurl {
    url = "https://s3.amazonaws.com/prerelease.keybase.io/linux_binaries/deb/keybase_${version + "-" + versionSuffix}_amd64.deb";
    sha256 = "0nwz0v6sqx1gd7spha09pk2bjbb8lgaxbrh0r6j6p0xzgzz6birw";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome3.gsettings-desktop-schemas
    gtk3
    libnotify
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ];

  runtimeDependencies = [
    udev.lib
  ];

  dontBuild = true;
  dontConfigure = true;
  dontPatchElf = true;

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

    if [ -z "\$(keybase status | grep kbfsfuse)" ]; then
      echo "Could not find kbfsfuse client in keybase status." >&2
      echo "You might need to run: kbfsfuse" >&2
      checkFailed
    fi

    exec $out/share/keybase/Keybase "\$@"
    EOF
    chmod +x $out/bin/keybase-gui

    substituteInPlace $out/share/applications/keybase.desktop \
      --replace run_keybase $out/bin/keybase-gui
  '';

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official GUI";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvolosatovs puffnfresh np ];
    license = licenses.bsd3;
  };
}
