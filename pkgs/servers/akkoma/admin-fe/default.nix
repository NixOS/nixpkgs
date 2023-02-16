{ lib
, stdenv
, fetchFromGitea, fetchYarnDeps
, fixup_yarn_lock, yarn, nodejs
, python3, pkg-config, libsass
}:

stdenv.mkDerivation rec {
  pname = "admin-fe";
  version = "unstable-2022-09-10";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "admin-fe";
    rev = "e094e12c3ecb540df839fdf20c5a03d10454fcad";
    hash = "sha256-dqkW8p4x+5z1Hd8gp8V4+DsLm8EspVwPXDxtvlp1AIk=";
  };

  patches = [ ./deps.patch ];

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-h+QUBT2VwPWu2l05Zkcp+0vHN/x40uXxw2KYjq7l/Xk=";
  };

  nativeBuildInputs = [
    fixup_yarn_lock
    yarn
    nodejs
    pkg-config
    python3
    libsass
  ];

  postPatch = ''
    cp ${./yarn.lock} yarn.lock
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$(mktemp -d)"

    yarn config --offline set yarn-offline-mirror ${lib.escapeShellArg offlineCache}
    fixup_yarn_lock yarn.lock

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
    license = licenses.agpl3;
    maintainers = with maintainers; [ mvs ];
  };
}
