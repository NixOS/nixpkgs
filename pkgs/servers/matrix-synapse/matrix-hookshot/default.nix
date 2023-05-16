{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, matrix-sdk-crypto-nodejs
, mkYarnPackage
, rust
, cargo
, rustPlatform
, rustc
, napi-rs-cli
<<<<<<< HEAD
, pkg-config
, nodejs
, openssl
=======
, nodejs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  data = lib.importJSON ./pin.json;
in
mkYarnPackage rec {
  pname = "matrix-hookshot";
  version = data.version;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-hookshot";
    rev = data.version;
<<<<<<< HEAD
    hash = data.srcHash;
=======
    sha256 = data.srcHash;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = data.yarnHash;
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = data.cargoHash;
=======
    sha256 = data.cargoHash;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  packageResolutions = {
    "@matrix-org/matrix-sdk-crypto-nodejs" = "${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs";
  };

<<<<<<< HEAD
  extraBuildInputs = [ openssl ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    pkg-config
=======
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cargo
    rustc
    napi-rs-cli
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    cd deps/${pname}
    napi build --target ${rust.toRustTargetSpec stdenv.targetPlatform} --dts ../src/libRs.d.ts --release ./lib
    yarn run build:app:fix-defs
    yarn run build:app
    yarn run build:web
    cd ../..
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-hookshot" --add-flags \
        "$out/libexec/matrix-hookshot/deps/matrix-hookshot/lib/App/BridgeApp.js"
  '';

  doDist = false;

  meta = with lib; {
    description = "A bridge between Matrix and multiple project management services, such as GitHub, GitLab and JIRA";
    maintainers = with maintainers; [ chvp ];
    license = licenses.asl20;
<<<<<<< HEAD
    platforms = platforms.linux;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
