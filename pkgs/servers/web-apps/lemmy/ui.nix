{
  lib,
  mkYarnPackage,
  libsass,
  nodejs,
  python3,
  pkg-config,
  fetchFromGitHub,
  fetchYarnDeps,
  nixosTests,
  vips,
  nodePackages,
}:

let
  pinData = lib.importJSON ./pin.json;

  pkgConfig = {
    node-sass = {
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libsass
        python3
      ];
      postInstall = ''
        LIBSASS_EXT=auto yarn --offline run build
        rm build/config.gypi
      '';
    };
    sharp = {
      nativeBuildInputs = [
        pkg-config
        nodePackages.node-gyp
        nodePackages.semver
      ];
      buildInputs = [ vips ];
      postInstall = ''
        yarn --offline run install
      '';
    };
  };

  name = "lemmy-ui";
  version = pinData.uiVersion;

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = name;
    rev = version;
    fetchSubmodules = true;
    hash = pinData.uiHash;
  };
in
mkYarnPackage {

  inherit
    src
    pkgConfig
    name
    version
    ;

  extraBuildInputs = [ libsass ];

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = pinData.uiYarnDepsHash;
  };

  patchPhase = ''
    substituteInPlace ./package.json \
      --replace '$(git rev-parse --short HEAD)' "${src.rev}" \
      --replace 'yarn clean' 'yarn --offline clean' \
      --replace 'yarn run rimraf dist' 'yarn --offline run rimraf dist'
  '';

  yarnPreBuild = ''
    export npm_config_nodedir=${nodejs}
  '';

  buildPhase = ''
    # Yarn writes cache directories etc to $HOME.
    export HOME=$PWD/yarn_home

    ln -sf $PWD/node_modules $PWD/deps/lemmy-ui/
    echo 'export const VERSION = "${version}";' > $PWD/deps/lemmy-ui/src/shared/version.ts

    yarn --offline build:prod
  '';

  preInstall = ''
    mkdir $out
    cp -R ./deps/lemmy-ui/dist $out
    cp -R ./node_modules $out
  '';

  distPhase = "true";

  passthru.updateScript = ./update.py;
  passthru.tests.lemmy-ui = nixosTests.lemmy;
  passthru.commit_sha = src.rev;

  meta = with lib; {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      happysalada
      billewanick
    ];
    inherit (nodejs.meta) platforms;
  };
}
