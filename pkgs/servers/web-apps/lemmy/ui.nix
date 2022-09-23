{ lib
, mkYarnPackage
, libsass
, nodejs
, python3
, pkg-config
, fetchFromGitHub
, fetchYarnDeps
, nixosTests
}:

let
  pinData = lib.importJSON ./pin.json;

  pkgConfig = {
    node-sass = {
      nativeBuildInputs = [ ];
      buildInputs = [ libsass pkg-config python3 ];
      postInstall = ''
        LIBSASS_EXT=auto yarn --offline run build
        rm build/config.gypi
      '';
    };
  };

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

  inherit src pkgConfig name version;

  extraBuildInputs = [ libsass ];

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = pinData.uiYarnDepsSha256;
  };

  yarnPreBuild = ''
    export npm_config_nodedir=${nodejs}
  '';

  buildPhase = ''
    # Yarn writes cache directories etc to $HOME.
    export HOME=$PWD/yarn_home

    ln -sf $PWD/node_modules $PWD/deps/lemmy-ui/

    yarn --offline build:prod
  '';

  preInstall = ''
    mkdir $out
    cp -R ./deps/lemmy-ui/dist $out
    cp -R ./node_modules $out
  '';

  distPhase = "true";

  passthru.updateScript = ./update.sh;
  passthru.tests.lemmy-ui = nixosTests.lemmy;

  meta = with lib; {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada billewanick ];
    platforms = platforms.linux;
  };
}
