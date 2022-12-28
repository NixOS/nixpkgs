{ lib
, stdenv
, fetchFromGitea, fetchYarnDeps
, fixup_yarn_lock, yarn, nodejs
, jpegoptim, oxipng, nodePackages
}:

stdenv.mkDerivation rec {
  pname = "pleroma-fe";
  version = "unstable-2022-12-10";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "pleroma-fe";
    rev = "9c9b4cc07c018a21c8261dd7680a97aa3a670756";
    hash = "sha256-jYJcG2Q5kxOH29G5WV/6Cx7a+b7FuFROEn/8ruh7cDc=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-pz6NHBYZRi+Rwx6H74895vFWGLSivI7Ul8XV6wMbgJg=";
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
    description = "Frontend for Akkoma and Pleroma";
    homepage = "https://akkoma.dev/AkkomaGang/pleroma-fe/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mvs ];
  };
}
