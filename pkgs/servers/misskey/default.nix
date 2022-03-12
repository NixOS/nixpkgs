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
  version = "12.108.1";

  src = fetchFromGitHub {
    owner = "misskey-dev";
    repo = "misskey";
    rev = version;
    sha256 = "sha256-NTspyTNy3cqc43+YLeCKRR46D7BvtIWoNCmwgqykHgs=";
  };

  deps = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-1NEeuBVp5e7RtFzYeT4nTGxGs2oeTxqiz20pEZXmcbo=";
  };
  backendDeps = fetchYarnDeps {
    yarnLock = "${src}/packages/backend/yarn.lock";
    sha256 = "sha256-G01hkYthBCZnsvPNaTIXSgTN9/1inJXhh34umxfxUsc=";
  };
  clientDeps = fetchYarnDeps {
    yarnLock = "${src}/packages/client/yarn.lock";
    sha256 = "sha256-LwGjqHN59KditL3igVP1/TZ7cZSbrZopOl9A0c1nlW8=";
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
