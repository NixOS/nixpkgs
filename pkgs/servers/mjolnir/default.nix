{ lib
, mkYarnPackage
, fetchFromGitHub
, makeWrapper
, nodejs
}:

assert lib.versionAtLeast nodejs.version "10.0.0";

mkYarnPackage rec {
  pname = "mjolnir";

  # when updating, run `./generate.sh <git release tag>`
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "v${version}";
    sha256 = "sha256-uBI5AllXWgl3eL60WZ/j11Tt7QpY7CKcmFQOU74/Qjs=";
  };

  packageJSON = ./package.json;
  yarnNix = ./yarn-dependencies.nix;

  nativeBuildInputs = [ makeWrapper ];

  # compile TypeScript sources
  buildPhase = ''
    yarn --offline build
  '';

  doCheck = true;
  checkPhase = ''
    yarn --offline test
  '';

  postInstall = ''
    # server wrapper
    makeWrapper '${nodejs}/bin/node' "$out/bin/${pname}" \
      --add-flags "$out/${passthru.nodeAppDir}/lib/index.js"
  '';

  # don't generate the dist tarball
  # (`doDist = false` does not work in mkYarnPackage)
  distPhase = ''
    true
  '';

  passthru = {
    nodeAppDir = "libexec/${pname}/deps/${pname}";
  };

  meta = {
    description = "A moderation tool for Matrix.";
    homepage = "https://github.com/matrix-org/mjolnir";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sumnerevans ];
    platforms = lib.platforms.linux;
  };
}
