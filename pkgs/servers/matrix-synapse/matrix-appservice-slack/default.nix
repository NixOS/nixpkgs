{ lib
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, matrix-sdk-crypto-nodejs
, mkYarnPackage
, nodejs
}:

let
  data = lib.importJSON ./pin.json;
in
mkYarnPackage rec {
  inherit nodejs;

  pname = "matrix-appservice-slack";
  version = data.version;

  packageJSON = ./package.json;
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-slack";
    rev = data.version;
    hash = data.srcHash;
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = data.yarnHash;
  };
  packageResolutions = {
    "@matrix-org/matrix-sdk-crypto-nodejs" = "${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    yarn run build
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-slack" --add-flags \
        "$out/libexec/matrix-appservice-slack/deps/matrix-appservice-slack/lib/app.js"
  '';

  doDist = false;

  meta = with lib; {
    description = "A Matrix <--> Slack bridge";
    maintainers = with maintainers; [ beardhatcode chvp ];
    license = licenses.asl20;
  };
}
