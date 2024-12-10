{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
}:

mkYarnPackage rec {
  pname = "asar";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "electron";
    repo = "asar";
    rev = "v${version}";
    hash = "sha256-12FP8VRDo1PQ+tiN4zhzkcfAx9zFs/0MU03t/vFo074=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-/fV3hd98pl46+fgmiMH9sDQrrZgdLY1oF9c3TaIxRSg=";
  };

  doDist = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules"
    mv deps/@electron "$out/lib/node_modules"
    rm "$out/lib/node_modules/@electron/asar/node_modules"
    mv node_modules "$out/lib/node_modules/@electron/asar"

    mkdir "$out/bin"
    ln -s "$out/lib/node_modules/@electron/asar/bin/asar.js" "$out/bin/asar"

    runHook postInstall
  '';

  meta = {
    description = "Simple extensive tar-like archive format with indexing";
    homepage = "https://github.com/electron/asar";
    license = lib.licenses.mit;
    mainProgram = "asar";
    maintainers = with lib.maintainers; [ xvapx ];
  };
}
