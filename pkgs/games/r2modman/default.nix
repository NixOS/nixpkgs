{
  lib,
  stdenv,
  yarn,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  electron,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r2modman";
  version = "3.1.48";

  src = fetchFromGitHub {
    owner = "ebkr";
    repo = "r2modmanPlus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gm+Q2PXii53WQewl2vD4aUOo0yFuh+LFt8MEPB7ZqE0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-1JXd1pDGEFDG+ogXbEpl4WMYXwksJJJBx20ZPykc7OM=";
  };

  patches = [
    # Make it possible to launch Steam games from r2modman.
    ./steam-launch-fix.patch
  ];

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  configurePhase = ''
    runHook preConfigure

    # Workaround for webpack bug
    # https://github.com/webpack/webpack/issues/14532
    export NODE_OPTIONS="--openssl-legacy-provider"
    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline quasar build --mode electron --skip-pkg

    # Remove dev dependencies.
    yarn install --production --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/r2modman
    cp -r dist/electron/UnPackaged/. node_modules $out/share/r2modman

    (
      cd public/icons
      for img in *png; do
        dimensions=''${img#favicon-}
        dimensions=''${dimensions%.png}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp $img $out/share/icons/hicolor/$dimensions/apps/r2modman.png
      done
    )

    makeWrapper '${lib.getExe electron}' "$out/bin/r2modman" \
      --inherit-argv0 \
      --add-flags "$out/share/r2modman" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "r2modman";
      exec = "r2modman";
      icon = "r2modman";
      desktopName = "r2modman";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      keywords = [
        "launcher"
        "mod manager"
        "thunderstore"
      ];
    })
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    changelog = "https://github.com/ebkr/r2modmanPlus/releases/tag/v${finalAttrs.version}";
    description = "Unofficial Thunderstore mod manager";
    homepage = "https://github.com/ebkr/r2modmanPlus";
    license = lib.licenses.mit;
    mainProgram = "r2modman";
    maintainers = with lib.maintainers; [
      aidalgol
      huantian
    ];
    inherit (electron.meta) platforms;
  };
})
