{ lib
, mkYarnPackage
, libsass
, nodejs
, python3
, pkg-config
, fetchFromGitHub
, fetchYarnDeps
, nixosTests
<<<<<<< HEAD
, vips
, nodePackages
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  pinData = lib.importJSON ./pin.json;

  pkgConfig = {
    node-sass = {
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ libsass python3 ];
      postInstall = ''
        LIBSASS_EXT=auto yarn --offline run build
        rm build/config.gypi
      '';
    };
<<<<<<< HEAD
    sharp = {
      nativeBuildInputs = [ pkg-config nodePackages.semver ];
      buildInputs = [ vips ];
      postInstall = ''
        yarn --offline run install
      '';
    };
  };

  name = "lemmy-ui";
  version = pinData.uiVersion;
=======
  };

  name = "lemmy-ui";
  version = pinData.version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = name;
    rev = version;
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = pinData.uiHash;
=======
    sha256 = pinData.uiSha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
mkYarnPackage {

  inherit src pkgConfig name version;

  extraBuildInputs = [ libsass ];

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
<<<<<<< HEAD
    hash = pinData.uiYarnDepsHash;
  };

  patchPhase = ''
    substituteInPlace ./package.json \
      --replace '$(git rev-parse --short HEAD)' "${src.rev}" \
      --replace 'yarn clean' 'yarn --offline clean' \
      --replace 'yarn run rimraf dist' 'yarn --offline run rimraf dist'
  '';

=======
    sha256 = pinData.uiYarnDepsSha256;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  yarnPreBuild = ''
    export npm_config_nodedir=${nodejs}
  '';

  buildPhase = ''
    # Yarn writes cache directories etc to $HOME.
    export HOME=$PWD/yarn_home

    ln -sf $PWD/node_modules $PWD/deps/lemmy-ui/
<<<<<<< HEAD
    echo 'export const VERSION = "${version}";' > $PWD/deps/lemmy-ui/src/shared/version.ts
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    yarn --offline build:prod
  '';

  preInstall = ''
    mkdir $out
    cp -R ./deps/lemmy-ui/dist $out
    cp -R ./node_modules $out
  '';

  distPhase = "true";

<<<<<<< HEAD
  passthru.updateScript = ./update.py;
  passthru.tests.lemmy-ui = nixosTests.lemmy;
  passthru.commit_sha = src.rev;
=======
  passthru.updateScript = ./update.sh;
  passthru.tests.lemmy-ui = nixosTests.lemmy;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
<<<<<<< HEAD
    maintainers = with maintainers; [ happysalada billewanick adisbladis ];
    inherit (nodejs.meta) platforms;
=======
    maintainers = with maintainers; [ happysalada billewanick ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
