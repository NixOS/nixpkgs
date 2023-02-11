{ pkgs
, lib
, stdenv
, fetchFromGitLab
, makeWrapper
, python3
, fetchYarnDeps
, fixup_yarn_lock
, pkg-config
, libsass
, nodejs-16_x
}:

let
  yarn_env = (pkgs.yarn.override { nodejs = nodejs-16_x; });
  node = nodejs-16_x;
in
stdenv.mkDerivation rec {
  pname = "baserow-front";
  version = "1.14.0";
  src = fetchFromGitLab {
    owner = "bramw";
    repo = "baserow";
    rev = "refs/tags/${version}";
    hash = "sha256-zT2afl3QNE2dO3JXjsZXqSmm1lv3EorG3mYZLQQMQ2Q=";
  };

  nativeBuildInputs = [ python3 yarn_env fixup_yarn_lock nodejs-16_x pkg-config libsass ];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/web-frontend/yarn.lock";
    sha256 = "sha256-4WGU9GxBL82XmfaeRZtzwrRcTvL7yFfgpQ+enwq3xm8=";
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
    mkdir -p $out
    cp -r . $out
  '';

  distPhase = "true";

}
