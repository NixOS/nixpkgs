{ version, src, stdenv, lib, fetchFromGitHub, fetchYarnDeps, prefetch-yarn-deps, yarn, nodejs }:

stdenv.mkDerivation rec {
  inherit version src;

  pname = "rmfakecloud-webui";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/ui/yarn.lock";
    sha256 = "sha256-37P+acjaeG7TCyLoIHIHsB+DCUOsQOJ1H9T5SgajtLc=";
  };

  nativeBuildInputs = [ prefetch-yarn-deps yarn nodejs ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    cd ui
    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs node_modules
    export PATH=$PWD/node_modules/.bin:$PATH
    ./node_modules/.bin/react-scripts build
    mkdir -p $out
    cd ..
  '';

  installPhase = ''
    cp -r ui/build/* $out
  '';

  meta = with lib; {
    description = "Only the webui files for rmfakecloud";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
  };
}
