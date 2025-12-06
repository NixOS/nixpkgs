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
  version = "1.1.54";

  src = fetchzip {
    url = "https://registry.npmjs.org/meshcentral/-/meshcentral-1.1.54.tgz";
    hash = "sha256-mX2/CYAGMjEfbquxTtvtmh7G0PFI6LYnrQElixxbY1w=";
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
    hash = "sha256-t5lSKw6PX+mrQxYiglUsyWtqo0SGe3yYGFLA+bvCEPU=";
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
