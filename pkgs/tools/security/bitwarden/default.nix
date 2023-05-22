{ lib
, applyPatches
, buildNpmPackage
, dbus
, electron_24
, fetchFromGitHub
, fetchpatch
, glib
, gnome
, gtk3
, jq
, libsecret
, makeDesktopItem
, makeWrapper
, moreutils
, nodejs_18
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook
}:

let
  description = "A secure and free password manager for all of your devices";
  icon = "bitwarden";

  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_18; };
  electron = electron_24;

  version = "2023.4.0";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "bitwarden";
      repo = "clients";
      rev = "desktop-v${version}";
      sha256 = "sha256-TTKDl6Py3k+fAy/kcyiMbAAKQdhVnZTyRXV8D/VpKBE=";
    };

    patches = [
      # Bump electron to 24 and node to 18
      (fetchpatch {
        url = "https://github.com/bitwarden/clients/pull/5205.patch";
        hash = "sha256-sKSrh8RHXtxGczyZScjTeiGZgTZCQ7f45ULj/j9cp6M=";
      })
    ];
  };

  desktop-native = rustPlatform.buildRustPackage {
    pname = "bitwarden-desktop-native";
    inherit src version;
    sourceRoot = "source-patched/apps/desktop/desktop_native";
    cargoSha256 = "sha256-VW9DmSh9jvqFCZjH1SAYkydSGjXSVEbv4CmtoJBiw5Y=";

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
  npmDepsHash = "sha256-UXDn09qyM8GwfUiWLDhhyrGFZeKtTRmQArstw+tm5iE=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    jq
    makeWrapper
    moreutils
    python3
  ];

  preBuild = ''
    if [[ $(jq --raw-output '.devDependencies.electron' < package.json | grep -E --only-matching '^[0-9]+') != ${lib.escapeShellArg (lib.versions.major electron.version)} ]]; then
      echo 'ERROR: electron version mismatch'
      exit 1
    fi

    jq 'del(.scripts.postinstall)' apps/desktop/package.json | sponge apps/desktop/package.json
    jq '.scripts.build = ""' apps/desktop/desktop_native/package.json | sponge apps/desktop/desktop_native/package.json
    cp ${desktop-native}/lib/libdesktop_native.so apps/desktop/desktop_native/desktop_native.linux-x64-musl.node
  '';

  postBuild = ''
    pushd apps/desktop

    npm exec electron-builder -- \
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
