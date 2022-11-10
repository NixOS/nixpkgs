{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, mkYarnPackage
, nodejs
, sqlite
, pkgs
}:

mkYarnPackage rec {
  pname = "jellyseerr";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Fallenbagel";
    repo = "jellyseerr";
    rev = "v${version}";
    sha256 = "sha256-TD+ctPyciG7VN71zcTX49rZCU+/NY2ahFPtd3tw8AWY=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  doDist = false;

  nativeBuildInputs = [
    nodejs
    makeWrapper
    sqlite
  ];

  buildPhase = ''
    runHook preBuild
    yarn build
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/jellyseerr" --add-flags \
        "$out/libexec/jellyseerr/deps/jellyseerr/dist/index.js" \
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
    maintainers = with maintainers; [ tboerger ];
  };
}
