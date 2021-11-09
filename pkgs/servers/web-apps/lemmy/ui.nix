{ lib
, mkYarnPackage
, libsass
, nodejs
, python3
, pkg-config
, fetchFromGitHub
, fetchYarnDeps
}:

let
  pinData = lib.importJSON ./pin.json;

  name = "lemmy-ui";
  version = pinData.version;

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = name;
    rev = version;
    fetchSubmodules = true;
    sha256 = pinData.uiSha256;
  };
in
mkYarnPackage {

  inherit src name version;

  nativeBuildInputs = [ libsass pkg-config python3 ];

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = pinData.uiYarnDepsSha256;
  };

  npm_config_nodedir = nodejs;

  buildPhase = ''
    pushd node_modules/node-sass
    LIBSASS_EXT=auto npm run build
    rm build/config.gypi
    popd

    # Yarn writes cache directories etc to $HOME.
    export HOME=$PWD/yarn_home

    yarn --offline build:prod
  '';

  installPhase = ''
    mkdir $out
    cp -R ./deps/lemmy-ui/dist $out
    cp -R deps/${name}/node_modules $out
  '';

  distPhase = "true";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada billewanick ];
    platforms = platforms.linux;
  };
}
