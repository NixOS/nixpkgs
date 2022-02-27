{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, fixup_yarn_lock
, yarn
, nodejs
, python3
, pkg-config
, glib
, vips
}:

let
  version = "12.107.0";

  src = fetchFromGitHub {
    owner = "misskey-dev";
    repo = "misskey";
    rev = version;
    sha256 = "sha256-ovoqqFnWZe99yeYWKfiGR0BgyvOnWyb2wa026qKL8Io=";
  };

  deps = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-c8R5w0DffBtEkaePyPjJsb3OsNaN9lCDzf4QWSTfMPk=";
  };
  backendDeps = fetchYarnDeps {
    yarnLock = "${src}/packages/backend/yarn.lock";
    sha256 = "sha256-AJ9RB0fJTHELPoqshM9Tvaq/fXpwiiU55n4zvSvZRN4=";
  };
  clientDeps = fetchYarnDeps {
    yarnLock = "${src}/packages/client/yarn.lock";
    sha256 = "sha256-Jk3XCsrSUyRAaUC6tJBqBslmU2J26bJyw64TAovCLH8=";
  };

in stdenv.mkDerivation {
  pname = "misskey";
  inherit version src;

  nativeBuildInputs = [ fixup_yarn_lock yarn nodejs python3 pkg-config ];
  buildInputs = [ glib vips ];

  buildPhase = ''
    export HOME=$PWD
    export NODE_ENV=production

    # Build node modules
    fixup_yarn_lock yarn.lock
    fixup_yarn_lock packages/backend/yarn.lock
    fixup_yarn_lock packages/client/yarn.lock
    yarn config --offline set yarn-offline-mirror ${deps}
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    (
      cd packages/backend
      yarn config --offline set yarn-offline-mirror ${backendDeps}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    )
    (
      cd packages/client
      yarn config --offline set yarn-offline-mirror ${clientDeps}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    )
    patchShebangs node_modules
    patchShebangs packages/backend/node_modules
    patchShebangs packages/client/node_modules
    (
      cd packages/backend/node_modules/re2
      npm_config_nodedir=${nodejs} npm run rebuild
    )
    (
      cd packages/backend/node_modules/sharp
      npm_config_nodedir=${nodejs} ../.bin/node-gyp rebuild
    )

    yarn build
  '';

  installPhase = ''
    mkdir -p $out/packages/client
    ln -s /var/lib/misskey $out/files
    ln -s /run/misskey $out/.config
    cp -r locales node_modules built $out
    cp -r packages/backend $out/packages/backend
    cp -r packages/client/assets $out/packages/client/assets
  '';

  meta = with lib; {
    description = "Interplanetary microblogging platform. 🚀";
    homepage = "https://misskey-hub.net/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ yuka kloenk ];
    platforms = platforms.unix;
  };
}
