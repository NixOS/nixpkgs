{ pkgs
, lib
, stdenv
, fetchFromGitHub
, python3
, fetchYarnDeps
, fixup_yarn_lock
, pkg-config
, libsass
, nodejs-16_x
}:

let
  # For Node.js 16.x: https://gitlab.com/baserow/baserow/-/issues/1714
  yarn_env = (pkgs.yarn.override { nodejs = nodejs-16_x; });
  node = nodejs-16_x;
in
stdenv.mkDerivation rec {
  pname = "baserow-front";
  version = "1.16.0";
  src = fetchFromGitHub {
    owner = "bram2w";
    repo = "baserow";
    rev = "refs/tags/${version}";
    hash = "sha256-6kjZNM4tOEmM/wt3mqLk+iCQav7gR4y8psCViRlJMgo=";
  };

  nativeBuildInputs = [ python3 yarn_env fixup_yarn_lock nodejs-16_x pkg-config libsass ];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/web-frontend/yarn.lock";
    sha256 = "sha256-Q0a7vNUC/7qjSsm32iyMvWbIae8kBQkCr+XWZtlyUAA=";
  };

  buildPhase = ''
    runHook preBuild

    export HOME=$PWD
    export NODE_OPTIONS=--openssl-legacy-provider

    cd web-frontend
    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-scripts
    patchShebangs node_modules

    mkdir -p $HOME/.node-gyp/${node.version}
    echo 9 > $HOME/.node-gyp/${node.version}/installVersion

    ln -sfv ${node}/include $HOME/.node-gyp/${node.version}
    export npm_config_nodedir=${node}

    pushd node_modules/node-sass
    LIBSASS_EXT=auto yarn run build --offline
    popd

    NUXT_TELEMETRY_DISABLED=1 yarn build-local
    cd ../
    runHook postBuild
  '';

  installPhase = ''
    cp -r web-frontend $out
  '';

  distPhase = "true";

  meta = with lib; {
    description = "Frontend for no-code database and Airtable alternative";
    homepage = "https://baserow.io";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius julienmalka ];
  };
}
