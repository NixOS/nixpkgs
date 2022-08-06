{ lib, mkYarnPackage, fetchFromGitHub, runCommand, makeWrapper, python3, nodejs }:

assert lib.versionAtLeast nodejs.version "14.0.0";

let
  nodeSources = runCommand "node-sources" {} ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv node-* $out
  '';

in mkYarnPackage rec {
  pname = "matrix-appservice-discord";

  # when updating, run `./generate.sh <git release tag>`
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-discord";
    rev = "v${version}";
    sha256 = "sha256-RbyVtI33ofeQ195JOO8TutrgZ3hzLlP30Xvevd0MwdE=";
  };

  packageJSON = ./package.json;
  yarnNix = ./yarn-dependencies.nix;

  pkgConfig = {
    better-sqlite3 = {
      buildInputs = [ python3 ];
      postInstall = ''
        # build native sqlite bindings
        npm run build-release --offline --nodedir="${nodeSources}"
     '';
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    # compile TypeScript sources
    yarn --offline build
  '';

  doCheck = true;
  checkPhase = ''
    # the default 2000ms timeout is sometimes too short on our busy builders
    yarn --offline test --timeout 10000
  '';

  postInstall = ''
    OUT_JS_DIR="$out/${passthru.nodeAppDir}/build"

    # server wrapper
    makeWrapper '${nodejs}/bin/node' "$out/bin/${pname}" \
      --add-flags "$OUT_JS_DIR/src/discordas.js"

    # admin tools wrappers
    for toolPath in $OUT_JS_DIR/tools/*; do
      makeWrapper '${nodejs}/bin/node' "$out/bin/${pname}-$(basename $toolPath .js)" \
        --add-flags "$toolPath"
    done
  '';

  # don't generate the dist tarball
  doDist = false;

  passthru = {
    nodeAppDir = "libexec/${pname}/deps/${pname}";
  };

  meta = {
    description = "A bridge between Matrix and Discord";
    homepage = "https://github.com/Half-Shot/matrix-appservice-discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pacien ];
    platforms = lib.platforms.linux;
  };
}
