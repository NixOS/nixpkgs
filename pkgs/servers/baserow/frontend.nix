{ pkgs
, lib
, stdenv
, fetchFromGitHub
, python3
, fetchYarnDeps
, fixup_yarn_lock
, pkg-config
, libsass
, nodejs_16
}:

let
  # For Node.js 16.x: https://gitlab.com/baserow/baserow/-/issues/1714
  yarn_env = (pkgs.yarn.override { nodejs = nodejs_16; });
  node = nodejs_16;
  # Fix me for later: computation of `baserow_${modDir}` is very incorrect.
  mkBaserowFrontendModule = modDir: "${modDir}/web-frontend/modules/baserow_${modDir}/module.js";
  modules = lib.concatStringsSep "," (map mkBaserowFrontendModule [ "$out/premium" "$out/enterprise" ]);
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

  nativeBuildInputs = [ python3 yarn_env fixup_yarn_lock nodejs_16 pkg-config libsass ];

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
    mkdir -p $out
    cp -r web-frontend $out/web-frontend
    # Built-in plugins
    mkdir -p $out/premium
    cp -r premium/web-frontend $out/premium/web-frontend
    mkdir -p $out/enterprise
    cp -r enterprise/web-frontend $out/enterprise/web-frontend
    # Wrap nuxt with `ADDITIONAL_MODULES`
    # wrapProgram $out/node_modules/.bin/nuxt \
    #  --set ADDITIONAL_MODULES "${modules}"
  '';

  distPhase = "true";

  meta = with lib; {
    description = "Frontend for no-code database and Airtable alternative";
    homepage = "https://baserow.io";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius julienmalka ];
  };
}
