{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, fixup_yarn_lock
, yarn
, nodejs_18
, python3
, fetchYarnDeps
, electron
, desktopToDarwinBundle
, nest-cli
, libsass
, buildPackages
, pkg-config
, sqlite
, xdg-utils
}:
let
  nodejs = nodejs_18;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "redisinsight-electron";
  version = "2.32";

  src = fetchFromGitHub {
    owner = "RedisInsight";
    repo = "RedisInsight";
    rev = "${finalAttrs.version}";
    hash = "sha256-esaH10AyEooym/62F5LJL7oP5UmD6T2UX8g/9QniL9s=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    sha256 = "NHKttywAaWAYkciGzYCnm1speHrWsv1t+dxL1DZgM7o=";
  };

  feOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/redisinsight/yarn.lock";
    sha256 = "1S1KNUOtmywQ0eyqVS2oRlhpjcL9eps8CR7AtC9ujSU=";
  };

  apiOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/redisinsight/api/yarn.lock";
    sha256 = "P99+1Dhdg/vznC2KepPrVGNlrofJFydXkZVxgwprIx4=";
  };

  nativeBuildInputs = [ yarn fixup_yarn_lock nodejs makeWrapper python3 nest-cli libsass pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [ sqlite xdg-utils ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    yarn config --offline set yarn-offline-mirror $feOfflineCache
    fixup_yarn_lock redisinsight/yarn.lock
    yarn --offline --cwd redisinsight/ --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    yarn config --offline set yarn-offline-mirror $apiOfflineCache
    fixup_yarn_lock redisinsight/api/yarn.lock
    yarn --offline --cwd redisinsight/api/ --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    patchShebangs node_modules/
    patchShebangs redisinsight/node_modules/
    patchShebangs redisinsight/api/node_modules/

    mkdir -p "$HOME/.node-gyp/${nodejs.version}"
    echo 9 >"$HOME/.node-gyp/${nodejs.version}/installVersion"
    ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
    export npm_config_nodedir=${nodejs}

    pushd redisinsight
    # Build the sqlite3 package.
    npm_config_node_gyp="${buildPackages.nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js" npm rebuild --verbose --sqlite=${sqlite.dev} sqlite3
    popd

    substituteInPlace redisinsight/api/config/default.ts \
      --replace "process['resourcesPath']" "\"$out/share/redisinsight\"" \

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    yarn config --offline set yarn-offline-mirror $offlineCache

    pushd node_modules/node-sass
    LIBSASS_EXT=auto yarn run build --offline
    popd

    yarn --offline build:prod

    yarn --offline electron-builder \
      --dir ${if stdenv.isDarwin then "--macos" else "--linux"} ${if stdenv.hostPlatform.isAarch64 then "--arm64" else "--x64"} \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # resources
    mkdir -p "$out/share/redisinsight"
    mkdir -p "$out/share/redisinsight/static/resources/plugins"
    mkdir -p "$out/share/redisinsight/default"

    cp -r release/${if stdenv.isDarwin then "darwin-" else "linux-"}${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked/resources/{app.asar,app.asar.unpacked} $out/share/redisinsight/
    cp -r resources/ $out/share/redisinsight

    # icons
    for icon in "$out/resources/icons/*.png"; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/redisinsight.png"
    done

    ln -s "${finalAttrs.desktopItem}/share/applications" "$out/share/applications"

    makeWrapper '${electron}/bin/electron' "$out/bin/redisinsight" \
      --add-flags "$out/share/redisinsight/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --chdir "$out/share/redisinsight" \
      --argv0 "$out/share/redisinsight/app.asar"

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "redisinsight";
    exec = "redisinsight %u";
    icon = "redisinsight";
    desktopName = "RedisInsight";
    genericName = "RedisInsight Redis Client";
    comment = finalAttrs.meta.description;
    categories = [ "Development" ];
    startupWMClass = "redisinsight";
  };

  meta = with lib; {
    description = "RedisInsight Redis client powered by Electron";
    homepage = "https://github.com/RedisInsight/RedisInsight";
    license = licenses.sspl;
    maintainers = with maintainers; [ gmemstr ];
    platforms = [ "x86_64-linux" ];
  };
})
