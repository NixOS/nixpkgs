{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, matrix-sdk-crypto-nodejs
, mkYarnPackage
, rust
, rustPlatform
, napi-rs-cli
, nodejs
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
    sha256 = data.srcHash;
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = data.yarnHash;
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = data.cargoHash;
  };

  packageResolutions = {
    "@matrix-org/matrix-sdk-crypto-nodejs" = "${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
  };
}
