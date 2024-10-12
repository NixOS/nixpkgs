{ lib
, stdenv
, fetchFromGitea, fetchYarnDeps
, fixup-yarn-lock, yarn, nodejs
, jpegoptim, oxipng, nodePackages
}:

stdenv.mkDerivation rec {
  pname = "akkoma-fe";
  version = "3.11.0";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "akkoma-fe";
    rev = "v${version}";
    hash = "sha256-Z7psmIyOo8Rvwcip90JgxLhZ5SkkGB94QInEgm8UOjQ=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-Uet3zdjLdI4qpiuU4CtW2WwWGcFaOhotLLKfnsAUqho=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    yarn
    nodejs
    jpegoptim
    oxipng
    nodePackages.svgo
  ];

  postPatch = ''
    # Build scripts assume to be used within a Git repository checkout
    sed -E -i '/^let commitHash =/,/;$/clet commitHash = "${builtins.substring 0 7 src.rev}";' \
      build/webpack.prod.conf.js
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$(mktemp -d)"

    yarn config --offline set yarn-offline-mirror ${lib.escapeShellArg offlineCache}
    fixup-yarn-lock yarn.lock

    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NODE_ENV="production"
    export NODE_OPTIONS="--openssl-legacy-provider"
    yarn run build --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # (Losslessly) optimise compression of image artifacts
    find dist -type f -name '*.jpg' -execdir ${jpegoptim}/bin/jpegoptim -w$NIX_BUILD_CORES {} \;
    find dist -type f -name '*.png' -execdir ${oxipng}/bin/oxipng -o max -t $NIX_BUILD_CORES {} \;
    find dist -type f -name '*.svg' -execdir ${nodePackages.svgo}/bin/svgo {} \;

    cp -R -v dist $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Frontend for Akkoma";
    homepage = "https://akkoma.dev/AkkomaGang/akkoma-fe/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mvs ];
  };
}
