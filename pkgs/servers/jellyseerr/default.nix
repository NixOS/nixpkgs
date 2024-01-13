{ lib
, fetchFromGitHub
, makeWrapper
, mkYarnPackage
, nodejs
, fetchYarnDeps
, python3
}:

let
  pin = lib.importJSON ./pin.json;
in

mkYarnPackage rec {
  pname = "jellyseerr";
  inherit (pin) version;

  src = fetchFromGitHub {
    owner = "Fallenbagel";
    repo = "jellyseerr";
    rev = "v${version}";
    hash = pin.srcHash;
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = pin.yarnSha256;
  };

  doDist = false;

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  # Fixes "SQLite package has not been found installed" at launch
  pkgConfig.sqlite3 = {
    nativeBuildInputs = [ nodejs.pkgs.node-pre-gyp python3 ];
    postInstall = ''
      export CPPFLAGS="-I${nodejs}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node
      rm -r build-tmp-napi-v6
    '';
  };

  pkgConfig.bcrypt = {
    nativeBuildInputs = [ nodejs.pkgs.node-pre-gyp python3 ];
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
