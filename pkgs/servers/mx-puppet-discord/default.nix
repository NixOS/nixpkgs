{
  lib,
  stdenv,
  fetchFromGitLab,

  pkg-config,
  nodejs,
  yarn-berry_3,
  makeWrapper,

  libjpeg,
  pixman,
  cairo,
  pango,
  which,
  libpq,
}:

let
  yarn-berry = yarn-berry_3;
in
stdenv.mkDerivation rec {
  pname = "mx-puppet-discord";
  version = "0.1.1";

  src = fetchFromGitLab {
    group = "mx-puppet";
    owner = "discord";
    repo = "mx-puppet-discord";
    rev = "v${version}";
    hash = "sha256-ZhyjUt6Bz/0R4+Lq/IoY9rNjdwVE2qp4ZQLc684+T/0=";
  };

  patches = [
    # generated via the following commands:
    # `yarn up canvas -R`
    # `yarn set resolution "better-sqlite3@npm:^7.4.1" "npm:11.9.1"`
    ./a.patch
  ];

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes patches;
    hash = "sha256-3xgGrifz23LwnjUtganRvXfNonrMmKfCU8b+f0YurJA=";
  };

  nativeBuildInputs = [

    makeWrapper
    nodejs
    (nodejs.python.withPackages (ps: [ ps.setuptools ]))
    pkg-config
    which
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  buildInputs = [
    libjpeg
    pixman
    cairo
    pango
    libpq
  ];

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/mx-puppet-discord"
    cp -r ./build ./node_modules "$out/share/mx-puppet-discord"

    makeWrapper ${lib.getExe nodejs} "$out/bin/mx-puppet-discord" \
      --add-flags "$out/share/mx-puppet-discord/build/index.js"

    runHook postInstall
  '';

  meta = {
    description = "Discord puppeting bridge for matrix";
    license = lib.licenses.asl20;
    homepage = "https://gitlab.com/mx-puppet/discord/mx-puppet-discord";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "mx-puppet-discord";
  };
}
