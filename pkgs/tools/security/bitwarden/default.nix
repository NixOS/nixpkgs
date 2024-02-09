{ lib
, buildNpmPackage
, cargo
, copyDesktopItems
, dbus
, electron_27
, fetchFromGitHub
, fetchpatch2
, glib
, gnome
, gtk3
, jq
, libsecret
, makeDesktopItem
, makeWrapper
, moreutils
, napi-rs-cli
, nodejs_18
, patchutils_0_4_2
, pkg-config
, python3
, runCommand
, rustc
, rustPlatform
}:

let
  description = "A secure and free password manager for all of your devices";
  icon = "bitwarden";
  electron = electron_27;
in buildNpmPackage rec {
  pname = "bitwarden";
  version = "2024.1.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "desktop-v${version}";
    hash = "sha256-lDDy1b1yfw3nZrwEEkpvh6xYucgn20XHsGACc45eb2w=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/bitwarden/clients/pull/7508
      url = "https://github.com/amarshall/bitwarden-clients/commit/e85fa4ef610d9dd05bd22a9b93d54b0c7901776d.patch";
      hash = "sha256-P9MTsiNbAb2kKo/PasIm9kGm0lQjuVUxAJ3Fh1DfpzY=";
    })
  ];

  nodejs = nodejs_18;

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];
  npmWorkspace = "apps/desktop";
  npmDepsHash = "sha256-RR8Ua41D9SXymiPuabOnIab3byu8DR63rOfdeTaQpy4=";

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    patches = map
      (patch: runCommand
        (builtins.baseNameOf patch)
        { nativeBuildInputs = [ patchutils_0_4_2 ]; }
        ''
          < ${patch} filterdiff -p1 --include=${lib.escapeShellArg cargoRoot}'/*' > $out
        ''
      )
      patches;
    patchFlags = [ "-p4" ];
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-EiJjIWiyu8MvX3Tj0Fkeh0T0El5kdCko2maiY6kkPPA=";
  };
  cargoRoot = "apps/desktop/desktop_native";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    cargo
    copyDesktopItems
    jq
    makeWrapper
    moreutils
    napi-rs-cli
    pkg-config
    python3
    rustc
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk3
    libsecret
  ];

  preBuild = ''
    if [[ $(jq --raw-output '.devDependencies.electron' < package.json | grep -E --only-matching '^[0-9]+') != ${lib.escapeShellArg (lib.versions.major electron.version)} ]]; then
      echo 'ERROR: electron version mismatch'
      exit 1
    fi
  '';

  postBuild = ''
    pushd apps/desktop

    # desktop_native/index.js loads a file of that name regarldess of the libc being used
    mv desktop_native/desktop_native.* desktop_native/desktop_native.linux-x64-musl.node

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    popd
  '';

  doCheck = true;

  nativeCheckInputs = [
    dbus
    (gnome.gnome-keyring.override { useWrappedDaemon = false; })
  ];

  checkFlags = [
    "--skip=password::password::tests::test"
  ];

  checkPhase = ''
    runHook preCheck

    pushd ${cargoRoot}
    export HOME=$(mktemp -d)
    export -f cargoCheckHook runHook _eval _callImplicitHook
    export cargoCheckType=release
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      -- bash -e -c cargoCheckHook
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

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

    pushd apps/desktop/resources/icons
    for icon in *.png; do
      dir=$out/share/icons/hicolor/"''${icon%.png}"/apps
      mkdir -p "$dir"
      cp "$icon" "$dir"/${icon}.png
    done
    popd

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "bitwarden";
      exec = "bitwarden %U";
      inherit icon;
      comment = description;
      desktopName = "Bitwarden";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    inherit description;
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ amarshall kiwi ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bitwarden";
  };
}
