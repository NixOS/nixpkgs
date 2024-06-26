{
  lib,
  stdenv,
  fetchFromGitea,
  fetchYarnDeps,
  fixup-yarn-lock,
  yarn,
  nodejs,
  git,
  python3,
  pkg-config,
  libsass,
}:

stdenv.mkDerivation rec {
  pname = "admin-fe";
  version = "unstable-2024-04-27";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "admin-fe";
    rev = "7e16abcbaab10efa6c2c4589660cf99f820a718d";
    hash = "sha256-W/2Ay2dNeVQk88lgkyTzKwCNw0kLkfI6+Azlbp0oMm4=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-acF+YuWXlMZMipD5+XJS+K9vVFRz3wB2fZqc3Hd0Bjc=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    yarn
    nodejs
    pkg-config
    python3
    git
    libsass
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$(mktemp -d)"

    yarn config --offline set yarn-offline-mirror ${lib.escapeShellArg offlineCache}
    fixup-yarn-lock yarn.lock
    substituteInPlace yarn.lock \
      --replace-fail '"git://github.com/adobe-webplatform/eve.git#eef80ed"' '"https://github.com/adobe-webplatform/eve.git#eef80ed"'

    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/cross-env

    mkdir -p "$HOME/.node-gyp/${nodejs.version}"
    echo 9 >"$HOME/.node-gyp/${nodejs.version}/installVersion"
    ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
    export npm_config_nodedir=${nodejs}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd node_modules/node-sass
    LIBSASS_EXT=auto yarn run build --offline
    popd

    export NODE_OPTIONS="--openssl-legacy-provider"
    yarn run build:prod --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -R -v dist $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Admin interface for Akkoma";
    homepage = "https://akkoma.dev/AkkomaGang/akkoma-fe/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mvs ];
  };
}
