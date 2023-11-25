{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, nodejs
, prefetch-yarn-deps
, yarn
}:

stdenv.mkDerivation rec {
  pname = "lxd-ui";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    rev = "refs/tags/${version}";
    hash = "sha256-l9Fp/Vm7NxMCp5QcM8+frFyfahhPG7TyF6NhfU1SEaA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-R6OeaBC6xBHa229YGyc2LDjjenwvS805PW8ueU/o99I=";
  };

  nativeBuildInputs = [
    nodejs
    prefetch-yarn-deps
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r build/ui/ $out

    runHook postInstall
  '';

  meta = {
    description = "Web user interface for LXD.";
    homepage = "https://github.com/canonical/lxd-ui";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
