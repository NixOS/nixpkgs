{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  fixup-yarn-lock,
  yarn,
  nodejs_18,
  python3,
  fetchYarnDeps,
  electron,
  nest-cli,
  libsass,
  buildPackages,
  pkg-config,
  sqlite,
  xdg-utils,
}:

let
  nodejs = nodejs_18;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "redisinsight";
  version = "2.48.0";

  src = fetchFromGitHub {
    owner = "RedisInsight";
    repo = "RedisInsight";
    rev = finalAttrs.version;
    hash = "sha256-ek0Fp8v6j+mZPK2cEuFNrBgInXdYIKBBUg0UD1I51Sg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-ohtU1h6wrg7asXDxTt1Jlzx9GaS3zDrGQD9P9tgzCOE=";
  };

  feOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/redisinsight/yarn.lock";
    hash = "sha256-9xbIdDeLUEk4eNeK7RTwidqDGinA8SPfcumqml66kTw=";
  };

  apiOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/redisinsight/api/yarn.lock";
    hash = "sha256-4zbffuneTceMEyKb8atTXTFhTv0DhrsRMdepZWgoxMQ=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    nodejs
    makeWrapper
    python3
    nest-cli
    libsass
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    sqlite
    xdg-utils
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    yarn config --offline set yarn-offline-mirror ${finalAttrs.feOfflineCache}
    fixup-yarn-lock redisinsight/yarn.lock
    yarn --offline --cwd redisinsight/ --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    yarn config --offline set yarn-offline-mirror ${finalAttrs.apiOfflineCache}
    fixup-yarn-lock redisinsight/api/yarn.lock
    yarn --offline --cwd redisinsight/api/ --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    patchShebangs node_modules/
    patchShebangs redisinsight/node_modules/
    patchShebangs redisinsight/api/node_modules/

    mkdir -p "$HOME/.node-gyp/${nodejs.version}"
    echo 9 >"$HOME/.node-gyp/${nodejs.version}/installVersion"
    ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
    export npm_config_nodedir=${nodejs}

    # Build the sqlite3 package.
    pushd redisinsight
    npm_config_node_gyp="${buildPackages.nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js" npm rebuild --verbose --sqlite=${sqlite.dev} sqlite3
    popd

    # Build node-sass
    LIBSASS_EXT=auto npm rebuild --verbose node-sass

    substituteInPlace redisinsight/api/config/default.ts \
      --replace-fail "process['resourcesPath']" "\"$out/share/redisinsight\"" \

    # has irrelevant files
    rm -r resources/app

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}

    yarn --offline build:prod

    yarn --offline electron-builder \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/redisinsight"/{app,defaults,static/plugins,static/resources/plugins}

    cp -r release/*-unpacked/{locales,resources{,.pak}} "$out/share/redisinsight/app"
    mv "$out/share/redisinsight/app/resources/resources" "$out/share/redisinsight"

    # icons
    for icon in "$out/share/redisinsight/resources/icons"/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/redisinsight.png"
    done

    makeWrapper '${electron}/bin/electron' "$out/bin/redisinsight" \
      --add-flags "$out/share/redisinsight/app/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "redisinsight";
      exec = "redisinsight %u";
      icon = "redisinsight";
      desktopName = "RedisInsight";
      genericName = "RedisInsight Redis Client";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
      startupWMClass = "redisinsight";
    })
  ];

  meta = {
    description = "RedisInsight Redis client powered by Electron";
    homepage = "https://github.com/RedisInsight/RedisInsight";
    license = lib.licenses.sspl;
    maintainers = with lib.maintainers; [
      tomasajt
    ];
    platforms = lib.platforms.linux;
  };
})
