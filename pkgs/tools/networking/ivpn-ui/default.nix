{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs-16_x
, electron_24
, jq
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, ivpn
, openssl
, glib
}:

let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs-16_x; };
  electron = electron_24;

  desktopItem = makeDesktopItem {
    name = "IVPN";
    desktopName = "IVPN";
    comment = "UI interface for IVPN";
    genericName = "VPN client";
    exec = "ivpn-ui";
    icon = "ivpn";
    type = "Application";
    startupNotify = true;
    categories = [ "Network" ];
  };
in buildNpmPackage' rec {
  pname = "ivpn-ui";
  version = "3.10.14";

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    rev = "v${version}";
    hash = "sha256-zHBjAEVHjnHMuUutwQQCCcZ7+Fz3C4GCAV3/jgZgwhM=";
  };

  env = {
    ELECTRON_OVERRIDE_DIST_PATH = "${electron}/bin";
    ELECTRON_CACHE = ".cache/electron";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  npmBuildScript = "electron:build";
  npmDepsHash = "sha256-U7Jurq7Dv9oRZushf8yeHuqe3pKTBJ/9hpS/iQzIYkI=";

  sourceRoot = "source/ui";

  nativeBuildInputs = [
    jq
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [ desktopItem ];

  # electron-builder attempts to download Electron frow web,
  # so we need to provide a zipped version of Electron.
  # The version of Electron that we provide may differ from the one
  # in the package-lock.json file, but it should not cause any problems.
  preBuild = ''
    mkdir -p .cache/electron
    ln -sf ${electron.src} .cache/electron/electron-v$(jq -r '.devDependencies.electron' package.json)-linux-x64.zip

    substituteInPlace src/daemon-client/index.js \
      --replace "/usr/bin/gsettings" "${glib}/bin/gsettings" \
      --replace "/usr/bin/ivpn exclude" "${ivpn}/bin/ivpn exclude"

    substituteInPlace src/helpers/main_platform.js \
      --replace "/usr/bin/openssl" "${openssl}/bin/openssl"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/ivpn-ui $out/share/icons/hicolor/scalable/apps

    pushd dist_electron/linux-unpacked
    cp -r locales resources $out/opt/ivpn-ui
    cp ivpn-ui $out/bin
    popd

    cp References/Linux/ui/ivpnicon.svg $out/share/icons/hicolor/scalable/apps/ivpn.svg

    makeWrapper '${electron}/bin/electron' "$out/bin/ivpn-ui" \
      --add-flags $out/opt/ivpn-ui/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official IVPN Desktop app";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ataraxiasjel ];
  };
}
