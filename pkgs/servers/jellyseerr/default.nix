{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  python3,
  sqlite,
}:

mkYarnPackage rec {
  pname = "jellyseerr";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "Fallenbagel";
    repo = "jellyseerr";
    rev = "v${version}";
    hash = "sha256-B8Hnpi4XwK0WrHRgj7OSVUh49oRH9SVEHdzGbnDa8p8=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-ME19kHlVw0Q5oCytYQCUj4Ek0+712NkqB6eozOtF6/k=";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  # Fixes "SQLite package has not been found installed" at launch
  pkgConfig.sqlite3 = {
    nativeBuildInputs = [
      nodejs.pkgs.node-pre-gyp
      python3
      sqlite
    ];
    postInstall = ''
      export CPPFLAGS="-I${nodejs}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node --sqlite=${sqlite.dev}
      rm -r build-tmp-napi-v6
    '';
  };

  pkgConfig.bcrypt = {
    nativeBuildInputs = [
      nodejs.pkgs.node-pre-gyp
      python3
    ];
    postInstall = ''
      export CPPFLAGS="-I${nodejs}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node
    '';
  };

  buildPhase = ''
    runHook preBuild
    (
      shopt -s dotglob
      cd deps/jellyseerr
      rm -r config/*
      yarn build
      rm -r .next/cache
    )
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/jellyseerr" \
      --add-flags "$out/libexec/jellyseerr/deps/jellyseerr/dist/index.js" \
      --set NODE_ENV production
  '';

  doDist = false;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Fork of overseerr for jellyfin support";
    homepage = "https://github.com/Fallenbagel/jellyseerr";
    longDescription = ''
      Jellyseerr is a free and open source software application for managing
      requests for your media library. It is a a fork of Overseerr built to
      bring support for Jellyfin & Emby media servers!
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ camillemndn ];
    platforms = platforms.linux;
    mainProgram = "jellyseerr";
  };
}
