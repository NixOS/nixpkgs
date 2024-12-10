{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  makeWrapper,
  nodejs,
  stdenv,
  yarn,
}:

stdenv.mkDerivation rec {
  pname = "yaml-language-server";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "yaml-language-server";
    rev = version;
    hash = "sha256-DS5kMw/x8hP2MzxHdHXnBqqBGLq21NiZBb5ApjEe/ts=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-zHcxZ4VU6CGux72Nsy0foU4gFshK1wO/LTfnwOoirmg=";
  };

  nativeBuildInputs = [
    makeWrapper
    fixup-yarn-lock
    yarn
  ];

  buildInputs = [
    nodejs
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

    yarn --offline compile
    yarn --offline build:libs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p $out/bin $out/lib/node_modules/yaml-language-server
    cp -r . $out/lib/node_modules/yaml-language-server
    ln -s $out/lib/node_modules/yaml-language-server/bin/yaml-language-server $out/bin/

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/redhat-developer/yaml-language-server/blob/${src.rev}/CHANGELOG.md";
    description = "Language Server for YAML Files";
    homepage = "https://github.com/redhat-developer/yaml-language-server";
    license = lib.licenses.mit;
    mainProgram = "yaml-language-server";
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
