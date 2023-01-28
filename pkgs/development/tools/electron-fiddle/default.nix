{ buildFHSUserEnv
, electron_20
, fetchFromGitHub
, fetchYarnDeps
, fixup_yarn_lock
, git
, lib
, makeDesktopItem
, nodejs-16_x
, stdenvNoCC
, util-linux
, zip
}:

let
  pname = "electron-fiddle";
  version = "0.31.0";
  electron = electron_20;
  nodejs = nodejs-16_x;

  src = fetchFromGitHub {
    owner = "electron";
    repo = "fiddle";
    rev = "v${version}";
    hash = "sha256-GueLG+RYFHi3PVVxBTtpTHhfjygcQ6ZCbrp5n5I1gBM=";
  };

  inherit (nodejs.pkgs) yarn;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-WVH1A0wtQl5nR1hvaL6mzm/7XBvo311FPKmsxB82e4U=";
  };

  electronDummyMirror = "https://electron.invalid/";
  electronDummyDir = "nix";
  electronDummyFilename =
    builtins.baseNameOf (builtins.head (electron.src.urls));
  electronDummyHash =
    builtins.hashString "sha256" "${electronDummyMirror}${electronDummyDir}";

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version src;

    nativeBuildInputs = [ fixup_yarn_lock git nodejs util-linux yarn zip ];

    configurePhase = ''
      export HOME=$TMPDIR
      fixup_yarn_lock yarn.lock
      yarn config --offline set yarn-offline-mirror ${offlineCache}
      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules

      mkdir -p ~/.cache/electron/${electronDummyHash}
      cp -ra '${electron}/lib/electron' "$TMPDIR/electron"
      chmod -R u+w "$TMPDIR/electron"
      (cd "$TMPDIR/electron" && zip -0Xr ~/.cache/electron/${electronDummyHash}/${electronDummyFilename} .)
    '';

    buildPhase = ''
      ELECTRON_CUSTOM_VERSION='${electron.version}' \
        ELECTRON_MIRROR='${electronDummyMirror}' \
        ELECTRON_CUSTOM_DIR='${electronDummyDir}' \
        ELECTRON_CUSTOM_FILENAME='${electronDummyFilename}' \
        yarn --offline run package
    '';

    installPhase = ''
      mkdir -p "$out/lib/electron-fiddle/resources"
      cp "out/Electron Fiddle-"*/resources/app.asar "$out/lib/electron-fiddle/resources/"
      mkdir -p "$out/share/icons/hicolor/scalable/apps"
      cp assets/icons/fiddle.svg "$out/share/icons/hicolor/scalable/apps/electron-fiddle.svg"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "electron-fiddle";
    desktopName = "Electron Fiddle";
    comment = "The easiest way to get started with Electron";
    genericName = "Electron Fiddle";
    exec = "electron-fiddle %U";
    icon = "electron-fiddle";
    startupNotify = true;
    categories = [ "GNOME" "GTK" "Utility" ];
    mimeTypes = [ "x-scheme-handler/electron-fiddle" ];
  };

in
buildFHSUserEnv {
  name = "electron-fiddle";
  runScript = "${electron}/bin/electron ${unwrapped}/lib/electron-fiddle/resources/app.asar";
  extraInstallCommands = ''
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    ln -s "${unwrapped}/share/icons/hicolor/scalable/apps/electron-fiddle.svg" "$out/share/icons/hicolor/scalable/apps/"
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications"/*.desktop "$out/share/applications/"
  '';
  targetPkgs = pkgs:
    with pkgs;
    map lib.getLib [
      # for electron-fiddle itself
      udev

      # for running Electron 22.0.0 inside
      alsa-lib
      atk
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libdrm
      libnotify
      libxkbcommon
      mesa
      nspr
      nss
      pango
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb

      # for running Electron before 18.3.5/19.0.5/20.0.0 inside
      gdk-pixbuf

      # for running Electron before 16.0.0 inside
      xorg.libxshmfence

      # for running Electron before 11.0.0 inside
      xorg.libXcursor
      xorg.libXi
      xorg.libXrender
      xorg.libXtst

      # for running Electron before 10.0.0 inside
      xorg.libXScrnSaver

      # for running Electron before 8.0.0 inside
      libuuid

      # for running Electron before 4.0.0 inside
      fontconfig

      # for running Electron before 3.0.0 inside
      gnome2.GConf

      # Electron 2.0.8 is the earliest working version, due to
      # https://github.com/electron/electron/issues/13972
    ];

  meta = with lib; {
    description = "The easiest way to get started with Electron";
    homepage = "https://www.electronjs.org/fiddle";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
    platforms = electron.meta.platforms;
  };
}
