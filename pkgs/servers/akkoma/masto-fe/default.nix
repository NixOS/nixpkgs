{ lib, stdenv, fetchFromGitea, fetchYarnDeps, fixup_yarn_lock, yarn, nodejs
, jpegoptim, oxipng, nodePackages }:

stdenv.mkDerivation rec {
  pname = "masto-fe";
  version = "unstable-2023-04-14";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "masto-fe";
    rev = "0a6462682a706f04c5daa4a18f1fd78b307706b2";
    hash = "sha256-KB3PdohnLtmMHDobYGdRjYkk2QUkgGwILf6LXRPGCUk";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-qg6hQNMGL7M+FOI89vIz+l3Xxd69LuWnbxuUw/on054";
  };

  nativeBuildInputs =
    [ fixup_yarn_lock yarn nodejs jpegoptim oxipng nodePackages.svgo ];

  postPatch = ''
    # Build scripts assume to be used within a Git repository checkout
    #sed -E -i '/^let commitHash =/,/;$/clet commitHash = "${
      builtins.substring 0 7 src.rev
    }";' \
    #  build/webpack.prod.conf.js
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$(mktemp -d)"

    yarn config --offline set yarn-offline-mirror ${
      lib.escapeShellArg offlineCache
    }
    fixup_yarn_lock yarn.lock

    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NODE_ENV="production"
    export NODE_OPTIONS="--openssl-legacy-provider"
    yarn run build:production --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # (Losslessly) optimise compression of image artifacts
    find public/packs -type f -name '*.jpg' -execdir ${jpegoptim}/bin/jpegoptim -w$NIX_BUILD_CORES {} \;
    find public/packs -type f -name '*.png' -execdir ${oxipng}/bin/oxipng -o max -t $NIX_BUILD_CORES {} \;
    find public/packs -type f -name '*.svg' -execdir ${nodePackages.svgo}/bin/svgo {} \;
    find public/emoji -type f -name '*.svg' -execdir ${nodePackages.svgo}/bin/svgo {} \;


    cp -R -v public $out
    cp -R public/packs/sw.js $out/sw.js
    cp -R public/packs $out/packs
    cp -R public/emoji $out/emoji

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mastodon FE for Akkoma";
    homepage = "https://akkoma.dev/AkkomaGang/masto-fe/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ socksy ];
  };
}
