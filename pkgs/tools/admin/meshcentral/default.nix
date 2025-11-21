{
  lib,
  fetchzip,
  stdenv,
  fetchYarnDeps,
  nodejs_20,
  dos2unix,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meshcentral";
  version = "1.1.53";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.53.tgz";
    hash = "sha256-eO3Wo30hfDG+DZRqCCQdrNJjc61/nhgh6NJXzw7fVfI=";
  };

  # Tarball has CRLF line endings. This makes patching difficult, so let's convert them.
  prePatch = ''
    find . -name '*.js' -exec dos2unix {} +
  '';

  patches = [
    ./fix-js-include-paths.patch
  ];

  postPatch = ''
    cp ${./yarn.lock} ./yarn.lock
    chmod u+w ./yarn.lock
  '';

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) postPatch;
    yarnLock = ./yarn.lock;
    hash = "sha256-jrBRexn5xc0OiBDf9fFDe2ZB3PcFVSuOChGCUWU4hcs=";
  };

  nativeBuildInputs = [
    dos2unix
    yarnConfigHook
    yarnInstallHook
    nodejs_20
  ];

  preFixup = ''
    mkdir -p $out/bin
    chmod a+x $out/lib/node_modules/meshcentral/meshcentral.js
    patchShebangs $out/lib/node_modules/meshcentral/meshcentral.js
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.asl20;
    mainProgram = "meshcentral";
  };
})
