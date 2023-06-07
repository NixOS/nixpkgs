{ lib
, stdenv
, fetchFromGitea, fetchYarnDeps
, fixup_yarn_lock, yarn, nodejs
, jpegoptim, oxipng, nodePackages
}:

stdenv.mkDerivation rec {
  pname = "akkoma-fe";
  version = "unstable-2023-05-23";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "akkoma-fe";
    rev = "e530c2b4626fab3bc94736cb7d0774809717911f";
    hash = "sha256-dowo4YzlkfuQv1G4NclPrKyBwtOq7bEXruQY/BVjNyM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-Uet3zdjLdI4qpiuU4CtW2WwWGcFaOhotLLKfnsAUqho=";
  };

  nativeBuildInputs = [
    fixup_yarn_lock
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
    fixup_yarn_lock yarn.lock

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
    license = licenses.agpl3;
    maintainers = with maintainers; [ mvs ];
  };
}
