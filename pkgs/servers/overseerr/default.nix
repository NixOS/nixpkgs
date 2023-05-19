{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, mkYarnPackage
, nodejs
, sqlite
, fetchYarnDeps
, python3
, pkg-config
, glib
}:

let
  pin = lib.importJSON ./pin.json;
in

mkYarnPackage rec {
  pname = "overseerr";
  inherit (pin) version;

  src = fetchFromGitHub {
    owner = "sct";
    repo = "overseerr";
    rev = "v${version}";
    sha256 = pin.srcSha256;
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
      cd deps/overseerr
      rm -r config/*
      yarn build
      rm -r .next/cache
    )
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/overseerr" \
      --add-flags "$out/libexec/overseerr/deps/overseerr/dist/index.js" \
      --set NODE_ENV production
  '';

  meta = with lib; {
    description = "Request management and media discovery tool for the Plex ecosystem";
    homepage = "https://github.com/sct/overseerr";
    longDescription = ''
      Overseerr is a free and open source software application for managing requests
      for your media library.It integrates with your existing services,
      such as Sonarr, Radarr, and Plex!
    '';
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
