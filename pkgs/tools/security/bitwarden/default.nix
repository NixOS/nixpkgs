{ lib
, buildNpmPackage
, dbus
, electron
, fetchFromGitHub
, glib
, gnome
, gtk3
, jq
, libsecret
, makeDesktopItem
, makeWrapper
, moreutils
, nodejs_16
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook
}:

let
  description = "A secure and free password manager for all of your devices";
  icon = "bitwarden";

  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_16; };

  version = "2023.3.2";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "desktop-v${version}";
    sha256 = "sha256-KQDM7XDUA+yRv8y1K//rMCs4J36df42RVsiAXazJeYQ=";
  };

  desktop-native = rustPlatform.buildRustPackage {
    pname = "bitwarden-desktop-native";
    inherit src version;
    sourceRoot = "source/apps/desktop/desktop_native";
    cargoSha256 = "sha256-XsAmVYWPPnY0cgBzpO2aWx/fh85fKr8kMO98cDMzOKk=";

    patchFlags = [ "-p4" ];

    nativeBuildInputs = [
      pkg-config
      wrapGAppsHook
    ];

    buildInputs = [
      glib
      gtk3
      libsecret
    ];

    nativeCheckInputs = [
      dbus
      (gnome.gnome-keyring.override { useWrappedDaemon = false; })
    ];

    checkFlags = [
      "--skip=password::password::tests::test"
    ];

    checkPhase = ''
      runHook preCheck

      export HOME=$(mktemp -d)
      export -f cargoCheckHook runHook _eval _callImplicitHook
      dbus-run-session \
        --config-file=${dbus}/share/dbus-1/session.conf \
        -- bash -e -c cargoCheckHook
      runHook postCheck
    '';
  };

  desktopItem = makeDesktopItem {
    name = "bitwarden";
    exec = "bitwarden %U";
    inherit icon;
    comment = description;
    desktopName = "Bitwarden";
    categories = [ "Utility" ];
  };

in

buildNpmPackage' {
  pname = "bitwarden";
  inherit src version;

  makeCacheWritable = true;
  npmBuildFlags = [
    "--workspace apps/desktop"
  ];
  npmDepsHash = "sha256-RmkTWhakZstCCMLQ3iJ8KD5Yt5ZafXc8NDgncJMLaxs=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    jq
    makeWrapper
    moreutils
    python3
  ];

  preBuild = ''
    jq 'del(.scripts.postinstall)' apps/desktop/package.json | sponge apps/desktop/package.json
    jq '.scripts.build = ""' apps/desktop/desktop_native/package.json | sponge apps/desktop/desktop_native/package.json
    cp ${desktop-native}/lib/libdesktop_native.so apps/desktop/desktop_native/desktop_native.linux-x64-musl.node
  '';

  postBuild = ''
    pushd apps/desktop

    "$(npm bin)"/electron-builder \
      --dir \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    popd
  '';

  installPhase = ''
    mkdir $out

    pushd apps/desktop/dist/linux-unpacked
    mkdir -p $out/opt/Bitwarden
    cp -r locales resources{,.pak} $out/opt/Bitwarden
    popd

    makeWrapper '${electron}/bin/electron' "$out/bin/bitwarden" \
      --add-flags $out/opt/Bitwarden/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    pushd apps/desktop/resources/icons
    for icon in *.png; do
      dir=$out/share/icons/hicolor/"''${icon%.png}"/apps
      mkdir -p "$dir"
      cp "$icon" "$dir"/${icon}.png
    done
    popd
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3;
    maintainers = with maintainers; [ amarshall kiwi ];
    platforms = [ "x86_64-linux" ];
  };
}
