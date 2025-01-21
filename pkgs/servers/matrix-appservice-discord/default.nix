{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  srcOnly,
  makeWrapper,
  removeReferencesTo,
  python3,
  nodejs,
  matrix-sdk-crypto-nodejs,
}:

let
  pin = lib.importJSON ./pin.json;
  nodeSources = srcOnly nodejs;

in
mkYarnPackage rec {
  pname = "matrix-appservice-discord";
  inherit (pin) version;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-discord";
    rev = "v${version}";
    hash = pin.srcHash;
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = pin.yarnSha256;
  };

  pkgConfig = {
    "@matrix-org/matrix-sdk-crypto-nodejs" = {
      postInstall = ''
        # replace with the built package
        cd ..
        rm -r matrix-sdk-crypto-nodejs
        ln -s ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/* ./
      '';
    };

    better-sqlite3 = {
      nativeBuildInputs = [ python3 ];
      postInstall = ''
        # build native sqlite bindings
        npm run build-release --offline --nodedir="${nodeSources}"
        find build -type f -exec \
          ${removeReferencesTo}/bin/remove-references-to \
          -t "${nodeSources}" {} \;
      '';
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild

    # compile TypeScript sources
    yarn --offline build

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # the default 2000ms timeout is sometimes too short on our busy builders
    yarn --offline test --timeout 10000

    runHook postCheck
  '';

  postInstall = ''
    OUT_JS_DIR="$out/${passthru.nodeAppDir}/build"

    # server wrapper
    makeWrapper '${nodejs}/bin/node' "$out/bin/${pname}" \
      --add-flags "$OUT_JS_DIR/src/discordas.js"

    # admin tools wrappers
    for toolPath in $OUT_JS_DIR/tools/*; do
      makeWrapper '${nodejs}/bin/node' \
        "$out/bin/${pname}-$(basename $toolPath .js)" \
        --add-flags "$toolPath"
    done
  '';

  # don't generate the dist tarball
  doDist = false;

  passthru = {
    nodeAppDir = "libexec/${pname}/deps/${pname}";
    updateScript = ./update.sh;
  };

  meta = {
    description = "Bridge between Matrix and Discord";
    homepage = "https://github.com/Half-Shot/matrix-appservice-discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ euxane ];
    platforms = lib.platforms.linux;
    mainProgram = "matrix-appservice-discord";
  };
}
