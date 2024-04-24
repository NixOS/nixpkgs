{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, fixup-yarn-lock
, yarn
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marp-cli";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bx5mq5KI85qUct/9Hr6mby6dWmRkmpVbiIw+M8PZas8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-BogCt7ezmWxv2YfhljHYoBf47/FHR0qLZosjnoQhqgs=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    fixup-yarn-lock
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
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

    yarn --offline --production install

    mkdir -p $out/lib/node_modules/@marp-team/marp-cli
    cp -r lib node_modules marp-cli.js $out/lib/node_modules/@marp-team/marp-cli/

    makeWrapper "${nodejs}/bin/node" "$out/bin/marp" \
      --add-flags "$out/lib/node_modules/@marp-team/marp-cli/marp-cli.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ GuillaumeDesforges ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
})
